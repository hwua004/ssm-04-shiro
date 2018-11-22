package com.hwua.ssm.entity;

import lombok.*;
import lombok.experimental.Accessors;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Accessors(chain=true)
public class Good {
    private Integer id;
    private String name;
    private Double price;
    private String type;


    public static void main(String[] args) {
        Good good= new Good(1,"手机",1999.99,"通讯");
        good.setId(2);
        good.setName("computer");
        good.setId(3).setName("吹风机").setPrice(99.99).setType("小家电");
    }

}
