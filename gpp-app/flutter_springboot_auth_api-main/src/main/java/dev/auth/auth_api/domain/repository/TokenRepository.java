package dev.auth.auth_api.domain.repository;

import dev.auth.auth_api.domain.model.Token;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public interface TokenRepository extends JpaRepository<Token, Long> {

    Boolean existsByAccessToken(String token);

    void deleteByAccessToken(String token);

    Token findByUsernameAndRefreshToken(String username, String token);

    Boolean existsByRefreshToken(String token);
}
