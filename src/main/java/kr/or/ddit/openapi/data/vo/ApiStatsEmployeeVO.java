package kr.or.ddit.openapi.data.vo;

import lombok.Data;

@Data
public class ApiStatsEmployeeVO {
    private String admCode;
    private int statsYear;
    private String bizCodeId;
    private long statsValue;
}