### Reactor란?

- 사용자 이벤트와 뷰의 state는 observable 스트림을 통해 각 계층에 전달됨
- 단방향 스트림
- 뷰는 actions만 emit할 수 있고, reactor는 states만 emit할 수 있음

### Reactor의 목표

- 비즈니스 로직을 뷰에서 분리하는 것을 통해 테스트 용이성 높이기
- 모든 뷰가 ReactorKit을 사용할 필요 없이 필요한 부분만 채택해서 쓰는 것(작게 구성하는 것)을 목표
- 간단한 것을 복잡한 코드로 작성되는 것을 방지

### 구성

- View
    - 데이터를 구성
        - ViewController / View로 처리
- Reactor
    - View의 UI State를 관리하는 독립적인 계층
    - 제어 흐름(비즈니스 로직)을 뷰에서 분리시키는 중요한 역할
    - 모든 뷰에는 해당 Reactor가 있으며 모든 논리를 Reactor에 위임
    - Reactor는 뷰에 대한 종속성이 없으므로 쉽게 테스트 가능
    - 구성
        - Action
            - 유저의 상호작용
        - State
            - 뷰의 상태
        - Mutation (변화)
            - Action과 State의 중간 브릿지 역할
    - reactor는 두 단계( mutate() / reduce() )로 액션 스트림을 상태 스트림으로 변환
    

### 예제

1. View
    - 기존 UIViewController를 상속받는 Class에 View 프로토콜을 준수하도록 설정
        - 그러면 클래스에 reactor 속성이 생김
        - 이 reactor 속성을 외부에서 inject을 통해 속성 변경 시킴
        
        ```swift
        class DefaultViewController: UIViewController, View {
        		var disposeBag = DisposeBag()
        }
        
        defaultViewController.reactor = DefaultViewReactor() // inject reactor
        ```
        
    - reactor 속성이 변경되면 bind(reactor:) 호출됨
    - 사용자 입력을 Action Stream에 바인딩하고 뷰 State를 각 UI 구성요소에 바인딩
        - 총 2번 바인딩을 함
        
        ```swift
        
        // reactor 속성 변경 시 자동으로 호출
        func bind(reactor: DefaultViewReactor) {
        	bindActions(reactor)
        	bindStates(reactor)
        }
        
        // 이벤트 action을 reactor로 전달
        // action (View -> Reactor)
        private func bindActions(_ reactor: DefaultViewReactor) {
        	button.rx.tap
        		.map { Reactor.Action.increase }
        		.bind(to: reactor.action)
        		.disposed(by: disposeBag)
        }
        
        // state를 통해 UI 갱신
        // action (Reactor -> View)
        private func bindStates(_ reactor: DefaultViewReactor) {
        	reactor.state
        		.map { String($0.value) }
        		.distinctUntilChanged()
        		.bind(to: label.rx.text)
        		.disposed(by: disposedBag)
        }
        ```
        

1. Reactor
    - Reactor 프로토콜을 준수하는 reactor 정의
    - 프로토콜은 세 가지 유형+한 가지 속성을 정의해야 함
        - Action / Mutation / State
        - initialState
        
        ```swift
        class DefaultViewReactor: Reactor {
        
        	// 유저 Action을 정의
        	enum Action {
        		case increase(Int)
        		case decrease(Int)
        	}
        	
        	// State 변화를 정의
        	enum Mutation {
        		case setFollowing(Bool)
        	}
        	
        	// 현재 State를 정의
        	struct State {
        		var isFollowing: Bool = false
        	}
        	
        	let initialState: State = State()
        }
        ```
        
    - mutate()
        - Action을 수신하고 Observable<Mutation>을 생성
            
            ```swift
            func mutate(action: Action) -> Observable<Mutation>
            ```
            
        - 비동기 작업이나 API 호출과 같은 Side Effect는 이 메서드에서 수행
            
            ```swift
            func mutate(action: Action) -> Observable<Mutation> {
            	switch action {
            		case let .increase(count):
            		return UserAPI.fetch(count)
            			.map { (isSuccess: Bool) -> Mutation in
            				return Mutation.setFollowing(isSuccess)
            			}
            		case ...
            	}
            }
            ```
            
    
    - reduce()
        - 이전 state과 mutation로부터 새로운 state를 생성
            
            ```swift
            func reduce(state: State, mutation: Mutation) -> State
            ```
            
        - 이 함수는 순수함수(특정 input에 대해서 항상 동일한 output을 반환하는 함수)이기 때문에 sideEffect를 구현하면 안됨
            
            ```swift
            func reduce(state: State, mutation: Mutation) -> State {
            	var state = state // 전 state를 가져와서 수정해야 함
            	switch mutation {
            		case let .setFollowing(isFollowing):
            			state.isFollowing = isFollowing // 새로운 state를 적용
            			return state
            	}
            }
            ```
