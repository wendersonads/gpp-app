package dev.auth.auth_api.base.service.impl;

import dev.auth.auth_api.base.model.AbstractEntity;
import dev.auth.auth_api.base.repository.AbstractRepository;
import dev.auth.auth_api.base.service.AbstractService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class AbstractServiceImpl<T extends AbstractEntity> implements AbstractService<T> {

    protected AbstractRepository<T> repository;

    public AbstractServiceImpl(final AbstractRepository<T> repository) {
        this.repository = repository;
    }

    @Override
    public List<T> findAll() {
        return repository.findAll();
    }

    @Override
    public T findById(Long id) {
        Optional<T> entity = repository.findById(id);
        return entity.orElse(null);
    }

    @Override
    public List<T> findAllEnabled() {
        return repository.findAllEnabled();
    }

    @Override
    public T save(T entity) {
        entity.setEnabled(true);
        entity.setCreation(LocalDateTime.now());
        return repository.save(entity);
    }

    @Override
    public List<T> saveAll(List<T> list) {
        List<T> entities = list.stream().peek(e -> {
            e.setEnabled(true);
            e.setCreation(LocalDateTime.now());
        }).collect(Collectors.toList());
        return repository.saveAll(entities);
    }

    @Override
    public T update(T entity) {
        return repository.save(entity);
    }

    @Override
    public T updateStatus(Long id) {
        T entity = repository.getById(id);
        entity.updateStatus();
        return repository.save(entity);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}
