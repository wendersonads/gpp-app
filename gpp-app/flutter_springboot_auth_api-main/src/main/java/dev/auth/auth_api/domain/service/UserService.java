package dev.auth.auth_api.domain.service;

import dev.auth.auth_api.domain.dto.RegisterDTO;
import dev.auth.auth_api.domain.enums.RoleEnum;
import dev.auth.auth_api.domain.model.User;
import dev.auth.auth_api.domain.repository.UserRepository;
import dev.auth.auth_api.core.util.ObjectUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;

@Service
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository repository;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = repository.findByUsername(username);
        if (ObjectUtil.isNull(user)) {
            throw new UsernameNotFoundException("User not found!");
        }
        Collection<SimpleGrantedAuthority> auths = new ArrayList<>();
        auths.add(new SimpleGrantedAuthority(user.getRole().toString()));
        return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), auths);
    }

    public void register(RegisterDTO register) {
        User _user = repository.findByUsername(register.getUsername());
        if (ObjectUtil.isNotNull(_user)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT);
        }
        _user = new User();
        _user.setUsername(register.getUsername());
        _user.setPassword(passwordEncoder.encode(register.getPassword()));
        _user.setRole(RoleEnum.USER_ROLE);
        _user.setCreation(LocalDate.now());
        repository.save(_user);
    }
}
