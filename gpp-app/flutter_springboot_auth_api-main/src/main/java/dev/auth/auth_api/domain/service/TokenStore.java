package dev.auth.auth_api.domain.service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.databind.ObjectMapper;
import dev.auth.auth_api.domain.model.Token;
import dev.auth.auth_api.domain.model.User;
import dev.auth.auth_api.domain.repository.TokenRepository;
import dev.auth.auth_api.domain.repository.UserRepository;
import dev.auth.auth_api.core.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

import static org.springframework.http.HttpHeaders.AUTHORIZATION;
import static org.springframework.http.HttpStatus.FORBIDDEN;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

@Service
public class TokenStore {

    @Autowired
    private TokenRepository repository;

    @Autowired
    private UserRepository userRepository;

    public Boolean check(String token) {
        return repository.existsByAccessToken(token);
    }

    public Boolean checkRefresh(String token) {
        return repository.existsByRefreshToken(token);
    }

    public void revoke(HttpServletRequest request) {
        String token1 = request.getHeader(AUTHORIZATION).substring("Bearer ".length());
        repository.deleteByAccessToken(token1);
    }

    public Token save(String username, String access_token, String refresh_token) {
        Token token1 = new Token();
        token1.setUsername(username);
        token1.setAccessToken(access_token);
        token1.setRefreshToken(refresh_token);
        return repository.save(token1);
    }

    public void refresh(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String header = request.getHeader(AUTHORIZATION);
        if (StringUtil.isNotNull(header) && header.startsWith("Bearer ")) {
            try {
                String refresh = header.substring("Bearer ".length());
                if (!checkRefresh(refresh)) {
                    throw new Exception("The provided token is not registered!");
                }
                Algorithm algorithm = Algorithm.HMAC256("@s3cr3t@".getBytes());
                JWTVerifier verifier = JWT.require(algorithm).build();
                DecodedJWT decodedJWT = verifier.verify(refresh);
                String usr = decodedJWT.getSubject();
                User user = userRepository.findByUsername(usr);
                Token updatedToken = repository.findByUsernameAndRefreshToken(usr, refresh);
                String access_token = JWT.create()
                        .withSubject(usr)
                        .withExpiresAt(new Date(System.currentTimeMillis() + 10 * 60 * 1000))
                        .withIssuer(request.getRequestURL().toString())
                        .withClaim("role", user.getRole().toString())
                        .sign(algorithm);
                String refresh_token = JWT.create()
                        .withSubject(usr)
                        .withExpiresAt(new Date(System.currentTimeMillis() + 30 * 60 * 1000))
                        .withIssuer(request.getRequestURL().toString())
                        .sign(algorithm);
                updatedToken.setAccessToken(access_token);
                updatedToken.setRefreshToken(refresh_token);
                Token token = repository.save(updatedToken);
                response.setContentType(APPLICATION_JSON_VALUE);
                new ObjectMapper().writeValue(response.getOutputStream(), token);
            } catch (Exception ex) {
                response.setHeader("error", ex.getMessage());
                response.setStatus(FORBIDDEN.value());
                Map<String, String> error = new HashMap<>();
                error.put("error_message", ex.getMessage());
                response.setContentType(APPLICATION_JSON_VALUE);
                new ObjectMapper().writeValue(response.getOutputStream(), error);
            }
        } else {
            throw new ResponseStatusException(FORBIDDEN, "The provided token is not registered!");
        }
    }
}
