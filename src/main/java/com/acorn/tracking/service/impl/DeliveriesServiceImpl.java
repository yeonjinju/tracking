package com.acorn.tracking.service.impl;

import java.math.BigDecimal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.acorn.tracking.domain.Deliveries;
import com.acorn.tracking.mapper.DeliveriesMapper;
import com.acorn.tracking.service.DeliveriesService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeliveriesServiceImpl implements DeliveriesService {

    private static final Logger logger = LoggerFactory.getLogger(DeliveriesServiceImpl.class);

    private final DeliveriesMapper deliveriesMapper;

    @Override
    public void autoInsertDelivery(int order_id) {
        try {
            Deliveries deliveries = Deliveries
                    .builder()
                    .order_id(order_id)
                    .delivery_status("배송중")
                    .latitude(new BigDecimal("37.56471"))
                    .longitude(new BigDecimal("126.97512"))
                    .build();

            deliveriesMapper.autoInsertDelivery(deliveries);
        } catch (Exception e) {
            logger.error("An error occurred while inserting the delivery for order ID: " + order_id, e);
        }
    }
}
