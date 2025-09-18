package kr.or.ddit.community.free.service.impl;

import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.community.free.mapper.NicknamePoolMapper;
import kr.or.ddit.community.free.mapper.VirtualNicknameMapper;
import kr.or.ddit.community.free.service.VirtualNicknameService;
import kr.or.ddit.community.free.vo.VirtualNicknameVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class VirtualNicknameServiceImpl implements VirtualNicknameService {
	   
	   private final VirtualNicknameMapper virtualNicknameMapper;
	    private final NicknamePoolMapper nicknamePoolMapper;

	    @Override // 인터페이스의 메소드를 구현한다는 의미의 @Override 추가
	    @Transactional
	    public String getOrCreateVirtualNickname(String userId, Long roomId, String userRole) {
	    	 if ("ROLE_ADMIN".equals(userRole)) { // 관리자 권한명은 실제 프로젝트에 맞게 확인해주세요.
	             return "관리자"; // 관리자일 경우, DB 조회 없이 바로 "관리자" 닉네임 반환
	         }
	        // (로직은 이전에 드렸던 것과 100% 동일합니다)
	        Optional<String> existingNickname = virtualNicknameMapper.findNickname(userId, roomId);

	        if (existingNickname.isPresent()) {
	            return existingNickname.get();
	        } else {
	            List<String> usedNicknames = virtualNicknameMapper.findUsedNicknamesInRoom(roomId);
	            List<String> allNicknames = nicknamePoolMapper.findAllNicknames();
	            
	            List<String> availableNicknames = allNicknames.stream()
	                    .filter(name -> !usedNicknames.contains(name))
	                    .collect(Collectors.toList());

	            String newNickname;
	            if (availableNicknames.isEmpty()) {
	                newNickname = "익명의 사용자" + new Random().nextInt(1000); 
	            } else {
	                newNickname = availableNicknames.get(new Random().nextInt(availableNicknames.size()));
	            }

	            VirtualNicknameVO vo = new VirtualNicknameVO();
	            vo.setUserId(userId);
	            vo.setRoomId(roomId);
	            vo.setVirtualNickname(newNickname);
	            virtualNicknameMapper.save(vo);

	            return newNickname;
	        }
	    }
	}