package kr.or.ddit.admin.stats.market.aop;

import java.lang.annotation.*;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface MarketLog {
    String value(); // "SIMPLE" or "DETAIL"
}