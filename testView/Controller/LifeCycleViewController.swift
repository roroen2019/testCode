//
//  LifeCycleViewController.swift
//  testView
//
//  Created by myPuppy on 2023/04/24.
//
/*
 뷰 컨트롤러 라이프사이클 테스트
 영상: https://www.youtube.com/watch?v=gmyEHW7zDYc
 */
import UIKit

class LifeCycleViewController: UIViewController {

    /*
     뷰를 생성하고 초기화하기 위한 메서드
     야곰 질문란의 답변을 보고 이해한점은 기본적인 self.view를 커스텀해서 사용하고싶다면 loadView메서드에서 뷰를 생성하고 리턴하면 된다.
     하지만 기본뷰를 따로 커스텀을 안한다면 loadView를 사용안하고 viewDidLoad에서 내가 만든 뷰를 올리고 사용하면 된다.
     공식문서에서는 사용하지 말라고 나와있음.
     */
    override func loadView() {
        super.loadView() //super로 호출하지말고 self.view = view() 형태로 해야한다, 지금은 스토리보드가 있어서 사용 super.loadView()
        print("\(#function)")
    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        print("\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(#function)")
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(#function)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(#function)")
    }
    
    /*
     뷰가 서브뷰의 배치를 조정하기 직전임을 뷰컨트롤러에게 알리는 메서드
     다음과 같은 작업을 수행할때 불러온다.
     1.뷰의 추가, 제거
     2.뷰들의 크기나 위치를 업데이트
     3.레이아웃 constraint를 업데이트
     4.뷰와 관련된 기타 프로퍼티들을 업데이트
     뷰가 갱신될 때마다 호출되므로 자주 실행된다. 불필요한 작업이 발생할 수 있으므로 주의.
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("\(#function)")
    }
    
    
    /*
     뷰가 서브뷰의 배치를 끝냈다는 소식을 뷰컨트롤러에게 알리는 메서드
     배치를 끝내고 작업할 때 불러온다.
     1.뷰의 크기나 위치를 최종적으로 조정
     2.테이블뷰의 데이터를 reload
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("\(#function)")
    }
    
    /*
     메모리에서 해제 되었을때 동작한다.
     */
    deinit {
        print("\(#function)")
    }
    
}
