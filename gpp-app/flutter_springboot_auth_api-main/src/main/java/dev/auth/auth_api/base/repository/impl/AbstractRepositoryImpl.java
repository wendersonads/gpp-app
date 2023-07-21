package dev.auth.auth_api.base.repository.impl;

import dev.auth.auth_api.base.model.AbstractEntity;
import dev.auth.auth_api.base.repository.AbstractRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.List;
import java.util.stream.Collectors;

@Transactional(readOnly = true)
public class AbstractRepositoryImpl<T extends AbstractEntity> extends SimpleJpaRepository<T, Long> implements AbstractRepository<T> {
    //Put the line @EnableJpaRepositories(repositoryBaseClass = AbstractRepositoryImpl.class) in the main class
    public AbstractRepositoryImpl(JpaEntityInformation<T, ?> entityInformation, EntityManager entityManager) {
        super(entityInformation, entityManager);
    }

    @Autowired
    public AbstractRepositoryImpl(Class<T> domainClass, EntityManager em) {
        super(domainClass, em);
    }

    @Override
    public List<T> findAllEnabled() {
        return super.findAll().stream().filter(AbstractEntity::getEnabled).collect(Collectors.toList());
    }
}
