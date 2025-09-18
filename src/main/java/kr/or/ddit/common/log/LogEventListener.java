package kr.or.ddit.common.log;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

import kr.or.ddit.admin.stats.user.vo.LogUserEventVO;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class LogEventListener {
  private final LogEventWriter writer;
  @Async("logEventExecutor")
  @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
  public void on(LogUserEventVO vo) { writer.writeAsync(vo); }
}