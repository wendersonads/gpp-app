package dev.auth.auth_api.core;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.databind.ObjectMapper;
import dev.auth.auth_api.domain.service.TokenStore;
import dev.auth.auth_api.core.util.StringUtil;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import static org.springframework.http.HttpHeaders.AUTHORIZATION;
import static org.springframework.http.HttpStatus.FORBIDDEN;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

public class CustomAuthorizationFilter extends OncePerRequestFilter {

    private TokenStore tokenStore;

    public CustomAuthorizationFilter(TokenStore tokenStore) {
        this.tokenStore = tokenStore;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filter) throws ServletException, IOException {
        if (request.getServletPath().equals("/auth/login") || request.getServletPath().equals("/auth/refresh")) {
            filter.doFilter(request, response);
        } else {
            String authHeader = request.getHeader(AUTHORIZATION);
            if (StringUtil.isNotNull(authHeader) && authHeader.startsWith("Bearer ")) {
                try {
                    String token = authHeader.substring("Bearer ".length());
                    if (!tokenStore.check(token)) {
                        throw new Exception("The provided token is not registered!");
                    }
                    Algorithm algorithm = Algorithm.HMAC256("@s3cr3t@".getBytes());
                    JWTVerifier verifier = JWT.require(algorithm).build();
                    DecodedJWT decodedJWT = verifier.verify(token);
                    String usr = decodedJWT.getSubject();
                    String role = decodedJWT.getClaim("role").toString();
                    Collection<SimpleGrantedAuthority> auths = new ArrayList<>();
                    auths.add(new SimpleGrantedAuthority(role));
                    UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(usr, null, auths);
                    SecurityContextHolder.getContext().setAuthentication(authenticationToken);
                    filter.doFilter(request, response);
                } catch (Exception ex) {
                    response.setHeader("error", ex.getMessage());
                    response.setStatus(FORBIDDEN.value());
                    Map<String, String> error = new HashMap<>();
                    error.put("error_message", ex.getMessage());
                    response.setContentType(APPLICATION_JSON_VALUE);
                    new ObjectMapper().writeValue(response.getOutputStream(), error);
                }
            } else {
                filter.doFilter(request, response);
            }
        }
    }
}
