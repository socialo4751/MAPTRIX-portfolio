package kr.or.ddit.common.code.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.code.vo.CodeGroupVO;

/**
 * @class CodeController
 * @description 공통 코드 조회를 위한 공용 REST API 컨트롤러입니다.
 * 이 컨트롤러는 프로젝트 전반에서 사용되는 드롭다운(select box), 라디오 버튼 등의
 * 옵션 목록을 동적으로 생성하는 데 사용됩니다.
 *
 * @author 아키텍트 (본인 이름)
 * @version 1.0
 *
 * =================================================================
 * @usage
 * [팀원들을 위한 사용법 가이드]
 *
 * 1. 목적:
 * - 프론트엔드(JSP, Vue, React 등)에서 하드코딩 없이 동적으로 옵션 목록을 가져오기 위해 사용합니다.
 * - 예: '직업' 드롭다운, '취미' 체크박스, '게시판 카테고리' 목록 등
 *
 * 2. 상세 코드 목록 가져오기 (가장 많이 사용될 기능):
 * - 특정 그룹에 속한 상세 코드 목록을 JSON 형태로 받아올 수 있습니다.
 * - Javascript의 fetch API를 사용하여 아래와 같이 호출하면 됩니다.
 *
 * [Javascript 예시 - 'JOB' 그룹의 상세 코드 가져오기]
 *
 * fetch('/codes/JOB')
 * .then(response => response.json())
 * .then(data => {
 * console.log(data);
 * // data는 [{codeId: 1, codeGroupId: 'JOB', codeName: '개발자'}, { ... }] 형태의 배열입니다.
 *
 * const selectBox = document.getElementById('jobSelectBox');
 * selectBox.innerHTML = ''; // 기존 옵션 초기화
 *
 * data.forEach(code => {
 * const option = document.createElement('option');
 * option.value = code.codeId; // or code.codeName
 * option.textContent = code.codeName;
 * selectBox.appendChild(option);
 * });
 * })
 * .catch(error => console.error('Error fetching codes:', error));
 *
 * 3. 전체 코드 그룹 목록 가져오기:
 * - 어떤 코드 그룹들이 있는지 확인하고 싶을 때 사용합니다. (주로 관리자 페이지에서 사용)
 * - API URL: GET /codes/groups
 * =================================================================
 */
@RestController
@RequestMapping("/codes")
public class CodeController {

    @Autowired
    private CodeService codeService;

    /**
     * 등록된 모든 공통 코드 그룹의 목록을 조회합니다.
     * @return JSON 형태의 CodeGroupVO 리스트
     */
    @GetMapping("/groups")
    public ResponseEntity<List<CodeGroupVO>> getCodeGroupList() {
        List<CodeGroupVO> codeGroupList = codeService.getCodeGroupList();
        return ResponseEntity.ok(codeGroupList);
    }

    /**
     * 특정 그룹 ID에 해당하는 상세 코드 목록을 조회합니다.
     * @param codeGroupId URL 경로에서 받아온 그룹 ID (예: "JOB", "HOBBY")
     * @return JSON 형태의 CodeDetailVO 리스트
     */
    @GetMapping("/{codeGroupId}")
    public ResponseEntity<List<CodeDetailVO>> getCodeDetailList(@PathVariable String codeGroupId) {
        List<CodeDetailVO> codeDetailList = codeService.getCodeDetailList(codeGroupId);
        return ResponseEntity.ok(codeDetailList);
    }
}
