package kr.or.ddit.openapi.data.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping; // Changed from GetMapping
import org.springframework.web.bind.annotation.RequestBody; // Changed from RequestParam
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.openapi.auth.service.ApiAuthService;
import kr.or.ddit.openapi.data.service.ApiDataService;
//... other imports
import kr.or.ddit.openapi.data.vo.ApiStatsBusinessVO;
import kr.or.ddit.openapi.data.vo.ApiStatsCreditCardVO;
import kr.or.ddit.openapi.data.vo.ApiStatsEmployeeVO;
import kr.or.ddit.openapi.data.vo.ApiStatsHouseholdVO;
import kr.or.ddit.openapi.data.vo.ApiStatsHousingVO;
import kr.or.ddit.openapi.data.vo.ApiStatsPopulationVO;

/**
 * @class Name : ApiDataController
 * @Description : 외부 프로그램의 요청에 따라 실제 데이터(JSON)를 제공하는 REST Controller
 */
@RestController
@RequestMapping("/api/v1")
public class ApiDataController {

    @Autowired
    private ApiDataService apiDataService;
    
    @LogEvent(eventType="CALL", feature="OPENAPI_POPULATION") 
    @PostMapping("/stats/population") // Changed to PostMapping
    public ResponseEntity<?> getPopulationStats(@RequestBody Map<String, Object> params) { // Changed to RequestBody
        
        List<ApiStatsPopulationVO> data = apiDataService.getPopulationStats(params);
        return new ResponseEntity<>(data, HttpStatus.OK);
    }

    @LogEvent(eventType="CALL", feature="OPENAPI_BUSINESS")
    @PostMapping("/stats/business") // Changed to PostMapping
    public ResponseEntity<?> getBusinessStats(@RequestBody Map<String, Object> params) { // Changed to RequestBody

        List<ApiStatsBusinessVO> data = apiDataService.getBusinessStats(params);
        return new ResponseEntity<>(data, HttpStatus.OK);
    }

    @LogEvent(eventType="CALL", feature="OPENAPI_EMPLOYEE")
    @PostMapping("/stats/employee") // Changed to PostMapping
    public ResponseEntity<?> getEmployeeStats(@RequestBody Map<String, Object> params) { // Changed to RequestBody

        List<ApiStatsEmployeeVO> data = apiDataService.getEmployeeStats(params);
        return new ResponseEntity<>(data, HttpStatus.OK);
    }

    @LogEvent(eventType="CALL", feature="OPENAPI_CREDITCARD")
    @PostMapping("/stats/credit-card") // Changed to PostMapping
    public ResponseEntity<?> getCreditCardStats(@RequestBody Map<String, Object> params) { // Changed to RequestBody
    
        List<ApiStatsCreditCardVO> data = apiDataService.getCreditCardStats(params);
        return new ResponseEntity<>(data, HttpStatus.OK);
    }

    @LogEvent(eventType="CALL", feature="OPENAPI_HOUSEHOLD")
    @PostMapping("/stats/household") // Changed to PostMapping
    public ResponseEntity<?> getHouseholdStats(@RequestBody Map<String, Object> params) { // Changed to RequestBody

        List<ApiStatsHouseholdVO> data = apiDataService.getHouseholdStats(params);
        return new ResponseEntity<>(data, HttpStatus.OK);
    }

    @LogEvent(eventType="CALL", feature="OPENAPI_HOUSING")
    @PostMapping("/stats/housing") // Changed to PostMapping
    public ResponseEntity<?> getHousingStats(@RequestBody Map<String, Object> params) { // Changed to RequestBody

        List<ApiStatsHousingVO> data = apiDataService.getHousingStats(params);
        return new ResponseEntity<>(data, HttpStatus.OK);
    }
}