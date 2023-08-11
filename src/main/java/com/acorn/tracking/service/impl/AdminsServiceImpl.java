package com.acorn.tracking.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.acorn.tracking.domain.Admins;
import com.acorn.tracking.mapper.AdminsMapper;
import com.acorn.tracking.service.AdminsService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminsServiceImpl implements AdminsService {

    private static final Logger logger = LoggerFactory.getLogger(AdminsServiceImpl.class);

    private final AdminsMapper adminsMapper;

    @Override
    public void insertAdmins() {
        try {
            Admins admins = Admins.builder()
                    .name("admin")
                    .email("admin@gmail.com")
                    .password("1234")
                    .build();
            adminsMapper.autoInsertAdmins(admins);
        } catch (Exception e) {
            logger.error("An error occurred while inserting admins", e);
        }
    }
}
