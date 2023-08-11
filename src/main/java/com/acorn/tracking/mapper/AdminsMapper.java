package com.acorn.tracking.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.acorn.tracking.domain.Admins;

@Mapper
public interface AdminsMapper {
    void autoInsertAdmins(Admins admins);
}
