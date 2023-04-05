//
//  OneViewController.swift
//  friend
//
//  Created by myPuppy on 2022/11/30.
//
/*
 페이지 번호 1
 */
import UIKit
import AlamofireImage
import CoreLocation //좌표
import SafariServices

class OneViewController: UIViewController {
    
    private let checkSign = AppConfig.defaultValue.signOut
    
    // 데이터
    private var bannerDataArray = [BannerList]() // 배너
    private var newAdopTionDataArray = [NewAdoptList]() //새로운 반려동물
    private var newsDataArray = [NewsList]()
    
    
    // 새로고침(refresh)
    private var refreshControl = UIRefreshControl()
    // 스크롤뷰 위치 확인
    private var scrollPage = 0
    // 처음 시작할때 위치 권한 받기위한 변수
    private var locationManager: CLLocationManager!
    // 한번만 실행시키기 위한 변수
    private var locationNumber = 0
    
    // 타이머
    private var timer: Timer?
    private var nowPage = 1
    
    // 배너 스크롤뷰
    private var bannerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    
    // 배너 컨테이너 뷰
    @IBOutlet weak var bannerContainerView: UIView!
    
    @IBOutlet weak var menuLabel: UILabel! //새로운 반려동물
    @IBOutlet weak var menuLabel1: UILabel! //댕댕 정보통
    
    @IBOutlet weak var percelOutCollectionView: UICollectionView! //분양
    
    
    @IBOutlet weak var contentsImageView: UIImageView! //콘텐츠 알아보기1
    
    @IBOutlet weak var contentsImageView2: UIImageView!
    
    
    @IBOutlet weak var moreButton: UIButton! //전체보기
    @IBOutlet weak var newsCollectionView: UICollectionView! //소식
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case moreButton:
            // 뉴스 전체보기 리스트로 이동
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NewsViewController") as? NewsViewController else{
                return
            }

            self.navigationController?.pushViewController(nextVC, animated: true) //푸쉬를 이용해서 화면전환 + 데이터 이동
            
        default:
            ()
        }
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationPermission()
        setupView()
        setupRefresh()
        setDynamicLink()
        addNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 자동 슬라이더 동작
        setupTimer(start: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        myLogPrint("OneViewController - viewDidAppear")
        checkSignOut()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        // 자동 슬라이더 멈춤
        setupTimer(start: false)
    }
    
    deinit {
        removeNotification()
    }

}

extension OneViewController {
    //MARK: - 뷰 설정
    private func setupView(){
        menuLabel.text = "새로운 반려동물"
        menuLabel.textColor = .black
        menuLabel.font = UIFont.SCDFont(type: .six, size: 16)
        
        menuLabel1.text = "댕댕 정보통"
        menuLabel1.textColor = .black
        menuLabel1.font = UIFont.SCDFont(type: .six, size: 16)
        
        // 반려동물 알아보기
        let contentsImage = UIImage(named: "homeContents")?.withRenderingMode(.alwaysOriginal)
        contentsImageView.image = contentsImage
        contentsImageView.contentMode = .scaleAspectFill
        contentsImageView.layer.cornerRadius = 10
//        let shadowColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.32)
//        contentsImageView.setShadow(rgba: shadowColor, x: 0, y: 3, blur: 6, spread: 0)
        contentsImageView.isUserInteractionEnabled = true
        let imageviewTap = UITapGestureRecognizer(target: self, action: #selector(imageviewTapGesture))
        contentsImageView.addGestureRecognizer(imageviewTap)
        
        // 보험 알아보기
        let contentsImage1 = UIImage(named: "homeContents1")?.withRenderingMode(.alwaysOriginal)
        contentsImageView2.image = contentsImage1
        contentsImageView2.contentMode = .scaleAspectFill
        contentsImageView2.layer.cornerRadius = 10
        contentsImageView2.isUserInteractionEnabled = true
        let imageviewTap1 = UITapGestureRecognizer(target: self, action: #selector(imageviewTapGesture1))
        contentsImageView2.addGestureRecognizer(imageviewTap1)
        
        // 전체보기> 버튼
        moreButton.setTitle("전체보기 >", for: .normal)
        let morebuttonColor = AppCustomColor.shared.gray102
        moreButton.setTitleColor(morebuttonColor, for: .normal)
        moreButton.titleLabel?.font = UIFont.SCDFont(type: .four, size: 10)
        
        
    }
    
    @objc private func imageviewTapGesture(){
        myLogPrint("콘텐츠 뷰로 이동하기")
        let storyboard = UIStoryboard(name: "Contents", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "ContentsViewController") as? ContentsViewController else{
            return
        }

        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @objc private func imageviewTapGesture1(){
        myLogPrint("보험화면으로 이동하기")
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "InsuranceViewController") as? InsuranceViewController else{
            return
        }
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    
    //MARK: 회원탈퇴 확인
    private func checkSignOut(){
        myLogPrint("회원탈퇴 확인:\(checkSign)")
        if self.checkSign {
            toastMessageView(view: self.view, message: "회원탈퇴 처리되었습니다.")
            AppConfig.defaultValue.signOut = false
        }
    }
    
    
    //MARK: 배너 설정
    private func setupBannerView(){
        self.bannerContainerView.addSubview(bannerScrollView)
        bannerScrollView.topAnchor.constraint(equalTo: self.bannerContainerView.topAnchor).isActive = true
        bannerScrollView.leadingAnchor.constraint(equalTo: self.bannerContainerView.leadingAnchor).isActive = true
        bannerScrollView.trailingAnchor.constraint(equalTo: self.bannerContainerView.trailingAnchor).isActive = true
        bannerScrollView.bottomAnchor.constraint(equalTo: self.bannerContainerView.bottomAnchor).isActive = true
        
        bannerScrollView.delegate = self
        bannerScrollView.isPagingEnabled = true
        bannerScrollView.showsHorizontalScrollIndicator = false
        bannerScrollView.backgroundColor = .gray
        
        // 스크롤뷰에 제스처 설정
        let headerGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureAction))
        headerGestureRecognizer.numberOfTouchesRequired = 1 //터치회수
        bannerScrollView.addGestureRecognizer(headerGestureRecognizer)
        bannerScrollView.isUserInteractionEnabled = true
        
        
        
        setupScrollView()
    }
    
    @objc func gestureAction(){
        myLogPrint("배너 스크롤 광고 탭:\(self.scrollPage)")
        // 웹페이지 열기
        let linkUrl = self.bannerDataArray[self.scrollPage].linkFullURL ?? ""
        guard let url = URL(string: linkUrl) else { return }
        let web = SFSafariViewController(url: url)
        self.present(web, animated: true)
    }
    
    
    //MARK: 콜렉션뷰 설정
    private func setupCollectionView(){
        
        // 분양
        let percelOutHeight = percelOutCollectionView.frame.size.height - 1
        
        let percelOutLayout = UICollectionViewFlowLayout()
        percelOutLayout.scrollDirection = .horizontal
        percelOutLayout.minimumLineSpacing = 20
        percelOutLayout.itemSize = CGSize(width: 150, height: percelOutHeight)
        
        percelOutCollectionView.collectionViewLayout = percelOutLayout
        percelOutCollectionView.register(percellOutCollectionViewCell.nib(), forCellWithReuseIdentifier: percellOutCollectionViewCell.identifier)
        percelOutCollectionView.delegate = self
        percelOutCollectionView.dataSource = self
        let leftPadding = AppConfig.defaultValue.leftPadding
        percelOutCollectionView.contentInset = .init(top: 0, left: leftPadding, bottom: 0, right: leftPadding)
        percelOutCollectionView.showsHorizontalScrollIndicator = false
        
        // 소식
        let newsHeight = newsCollectionView.frame.size.height - 1

        let newsLayout = UICollectionViewFlowLayout()
        newsLayout.scrollDirection = .horizontal
        newsLayout.minimumLineSpacing = 20
        newsLayout.itemSize = CGSize(width: 300, height: newsHeight)
        
        newsCollectionView.collectionViewLayout = newsLayout
        newsCollectionView.register(NewsCollectionViewCell.nib(), forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        newsCollectionView.contentInset = .init(top: 0, left: leftPadding, bottom: 0, right: leftPadding)
        newsCollectionView.showsHorizontalScrollIndicator = false
        
    }
    
    
    //MARK: 스크롤뷰 설정
    private func setupScrollView(){
        // 아이템 개수
        let number = bannerDataArray.count

        //print("광고 몇개냐?:\(number)")
        // 이미지 배열값이 0보다 클 경우에만 동작
        guard number > 0 else {
            return
        }
        
        // 아이템이 1개일경우
        if number == 1{
            bannerScrollView.isScrollEnabled = false //스크롤기능 끄기
            addViewIndex(url: bannerDataArray[0].imageFullURL ?? "", index: 0)
            return
        }
        
        // 2개이상부터 동작
        // 2개이상부터 아이템 배치 개수를 +2 한다 0, 마지막인덱스에 첫번째 아이템과, 마지막 아이템을 넣는다
        // 0인덱스에는 마지막 아이템, 라스트인덱스에는 첫번째 아이템 ex) 0,1,2,3 > 0-3, 1-1, 2-2, 3-1
        // 0번째 인덱스에 아이템 넣기
//        addViewIndex(url: responseAdvertising.last?.defaultThumb ?? "", index: 0)
        
        // 마지막 인덱스에 아이템 넣기
        addViewIndex(url: bannerDataArray[0].imageFullURL ?? "", index: number)
        // 중간 아이템 넣기
        for index in 0..<number{
            addViewIndex(url: bannerDataArray[index].imageFullURL ?? "", index: index)
        }
        
        // 스크롤뷰 사이즈 설정
        //print("스크롤뷰가로길이:\(headerScrollView.frame.size.width)")
//        bannerScrollView.contentSize.width = bannerScrollView.frame.size.width * CGFloat(number + 2) //첫번째, 마지막 아이템 추가/ 좌우로 한개씩 추가한다는 뜻
        bannerScrollView.contentSize.width = bannerContainerView.frame.size.width * CGFloat(number + 1) //마지막 아이템 추가/ 좌우로 한개씩 추가한다는 뜻
        
        // 스크롤 시작지점 설정(첫번째는 마지막 아이템이므로 2번째 지점에서 시작하도록 한다)
        // 스크롤뷰 가로길이가 viewDidLoad진행할때 0이므로 따로 가로길이를 계산해준다
//        let scrollWidth = self.frame.size.width - horizontalPadding * 2
//        let point = CGPoint(x: scrollWidth, y: 0)
//        let point = CGPoint(x: 0, y: 0)
//        bannerScrollView.setContentOffset(point, animated: false)
        
        
    }
    
    //MARK: - 이미지뷰 생성, 설정
    private func addViewIndex(url: String, index:Int){
        
        let view = UIImageView() //이미지뷰 생성
        let width = bannerContainerView.frame.size.width//가로
        let height = bannerContainerView.frame.size.height //세로
        let xPostion = width * CGFloat(index) //시작위치
        
        view.frame = CGRect(x: xPostion , y: 0, width: width, height: height) //이미지뷰 프레임 설정
        view.af.setImage(withURL: URL(string: url)!, placeholderImage: AppCommonValue.shared.placeholderImage, imageTransition: .crossDissolve(0.2))//이미지 넣기
        view.contentMode = .scaleAspectFill //이미지 비율 설정
        view.layer.masksToBounds = true
        bannerScrollView.addSubview(view) //컨텐츠뷰 안에 이미지뷰를 넣는다
        
    }
    
    
    //MARK: 타이머 설정
    private func setupTimer(start:Bool){
        switch start {
        case true:
            //2초 반복, 2초뒤에 코드 동작
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { Timer in
                // 스크롤 움직이기
                let xPosition = Int(self.bannerContainerView.frame.size.width) * self.nowPage
                self.bannerScrollView.setContentOffset(CGPoint(x: xPosition, y: 0), animated: true)
                self.nowPage += 1
                
            }
        case false:
            timer?.invalidate()
            timer = nil
        }
    }
    
    //MARK: 위치설정 권한 확인
    private func setupLocationPermission(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //정확도
        locationManager.requestWhenInUseAuthorization()
        
        // 위치권한 없으면 동작 안한다
        locationManager.startUpdatingLocation() //현재위치 가져오기
    }
    
    
    
    //MARK: 리프래쉬 설정
    private func setupRefresh(){
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        mainScrollView.refreshControl = refreshControl
    }
    
    @objc private func refresh(){
        print("@@@@ 리프래쉬 동작")
        // 리프래쉬 종료
        refreshControl.endRefreshing()
        
        requestHomeTap()
        
        percelOutCollectionView.reloadData()
        newsCollectionView.reloadData()
    }
    
    //MARK: 동적링크 수신처리하기(앱 처음 실행)
    private func setDynamicLink(){
        if let urlString = AppConfig.defaultValue.dynamicLink {
            myLogPrint("동적링크 url 확인;\(urlString)")
            // url 쿼리를 나누기
            self.getUrlParameter(url: urlString)
            
            // 초기화
            AppConfig.defaultValue.dynamicLink = nil
        }
    }
    
    //MARK: 노티피케이션 제거
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: .dynamicLink, object: nil)
    }
    
    
    //MARK: 노티피케이션 받기
    private func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceive(notification:)), name: .dynamicLink, object: nil)
    }
    
    @objc private func notificationReceive(notification:Notification){
        if let url = notification.object as? String {
            
            self.getUrlParameter(url: url)
        }
    }
    
    //MARK: url을 나눠 파라미터를 확인하기
    private func getUrlParameter(url:String){
        myLogPrint("동적링크 동작:\(url)")
        let components = URLComponents(string: url)
        let items = components?.queryItems ?? []
        
        // 동물상세보기로 이동해야 할때 필요한 값
        var petuid = ""
        var type = ""
        
        for item in items {
//            print("name :", item.name)
//            print("value :", item.value)
            
            // 펫
            if item.name == "petuid"{
                petuid = item.value ?? ""
            }
            // 전문분양 or 개인분양
            if item.name == "type"{
                type = item.value ?? ""
            }
            
            // 매장
            if item.name == "shopuid"{
                let storyboard = UIStoryboard(name: "Contents", bundle: nil)
                guard let nextVC = storyboard.instantiateViewController(withIdentifier: "ShopDetailViewController") as? ShopDetailViewController else{
                    return
                }

                self.removeViewControllerFromStack(nextVC)

                nextVC.uid = Int(item.value ?? "") ?? 0

                self.navigationController?.pushViewController(nextVC, animated: true)
                // 이곳이 동작하면 더이상 진행하지 않도록 한다
                return
            }
            
        }
        
        myLogPrint("uid:\(petuid), type:\(type)")
        let storyboard = UIStoryboard(name: "Contents", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "PercellDetailViewController") as? PercellDetailViewController else{
            return
        }
        
        self.removeViewControllerFromStack(nextVC)
        
        nextVC.uid = Int(petuid) ?? 0
        nextVC.kind = type == "pet" ? .pet : .shop

        self.navigationController?.pushViewController(nextVC, animated: true) //푸쉬를 이용해서 화면전환 + 데이터 이동
        
    }
    
    //MARK: 네비게이션컨트롤러 스택에서 뷰컨트롤러 확인하기
    private func removeViewControllerFromStack(_ viewControllerToRemove: UIViewController) {
        if var viewControllers = self.navigationController?.viewControllers {
            for (index, viewController) in viewControllers.enumerated() {
                if viewController.classForCoder == viewControllerToRemove.classForCoder {
                    // 특정 ViewController를 찾았으므로, 배열에서 삭제합니다.
                    viewControllers.remove(at: index)
                    self.navigationController?.setViewControllers(viewControllers, animated: true)
                    break // 루프를 중단합니다.
                }
            }
        }
    }
    
    
    //MARK: 서버통신 3-2
    private func requestHomeTap(){
        let url = "/screen/home"
        var parameters = Dictionary<String, Any>()
        parameters["nowLatAndLng"] = [
            AppConfig.defaultValue.myLat,
            AppConfig.defaultValue.myLng
        ]
        myLogPrint("\(url) - 파라미터 확인 : \(parameters)")
        CustomApi.shared.getResponseData(route: .apiMobile, addUrl: url, method: .get, parameters: parameters, encoding: .noBrackets) { result, data, statusCode  in
            switch result {
            case .value:
                myLogPrint("\(url) : 정상동작")
                
                switch statusCode {
                case 200, 201:
                    do{
                        // data를 뿌리기 쉽게 모델타입으로 디코딩한다
                        let getDecodingData = try JSONDecoder().decode(MainHomeData.self, from: data as! Data)

                        self.bannerDataArray = getDecodingData.bannerList
                        self.newAdopTionDataArray = getDecodingData.newAdoptList
                        self.newsDataArray = getDecodingData.newsList
                        
                        
                        self.setupBannerView()
                        self.setupCollectionView()
                        

                    }catch{
                        myLogPrint("\(url) - 디코딩 하는 과정에서 에러발생:\(error.localizedDescription)")
                        // 다른 데이터가 옴
                    }
                default:
                    myLogPrint("스테이터스 코드 확인:\(statusCode)")
                }
                
            case .apiError:
                myLogPrint("\(url) : api 에러 발생, code:\(data)")
                let errorCode = data as? String ?? ""
                apiErrorCode(vc: self, code: errorCode)
            case .httpError:
                myLogPrint("\(url) : 네트워크 에러 발생 : \(data)")
                toastMessageView(view: self.view, message: "네트워크 연결 상태가 좋지 않습니다.\n잠시후 다시 시도해 주세요")
            }
        }
    }
    
    
}

//MARK: - 콜렉션뷰 델리게이트
extension OneViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //MARK: 셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case percelOutCollectionView:
            let storyboard = UIStoryboard(name: "Contents", bundle: nil)
            guard let nextVC = storyboard.instantiateViewController(withIdentifier: "PercellDetailViewController") as? PercellDetailViewController else{
                return
            }
            
            let data = self.newAdopTionDataArray[indexPath.row]
            let adopt = data.adoptTypeLabel ?? ""
            myLogPrint("분양타입 확인:\(adopt)")
            if adopt == "전문분양" {
                nextVC.kind = .shop
            }else{
                nextVC.kind = .pet
            }
            myLogPrint("uid 확인:\(data.uid ?? 0)")
            nextVC.uid = data.uid ?? 0

            self.navigationController?.pushViewController(nextVC, animated: true) //푸쉬를 이용해서 화면전환 + 데이터 이동
            
            
        case newsCollectionView:
            
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController else{
                return
            }
            
            nextVC.url = self.newsDataArray[indexPath.row].htmlURL ?? ""
            
            self.navigationController?.pushViewController(nextVC, animated: true) //푸쉬를 이용해서 화면전환 + 데이터 이동
            
        default:
            ()
        }
    }
    
    
    //MARK: 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case percelOutCollectionView:
            return self.newAdopTionDataArray.count
        case newsCollectionView:
            return self.newsDataArray.count
        default:
            return 0
        }
    }
    
    //MARK: 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case percelOutCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: percellOutCollectionViewCell.identifier, for: indexPath) as? percellOutCollectionViewCell else {
                fatalError()
            }
            
            let data = self.newAdopTionDataArray[indexPath.row]
            let image = URL(string: data.imageFullURL ?? "")
            let insurance = data.hasInsurance ?? false
            let percel = data.adoptTypeLabel ?? ""
            let breed = data.breedLabel ?? ""
            let sex = data.gender ?? ""
            let age = data.age ?? ""
            
            cell.configure(image: image, insurance: insurance, percell: percel, breed: breed, sex: sex, age: age)
            
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as? NewsCollectionViewCell else {
                fatalError()
            }
            
            let data = self.newsDataArray[indexPath.row]
            let image = URL(string: data.imageFullURL ?? "")
            cell.configure(image: image)
            
            return cell
        }
    }
    
    
}

//MARK: - 스크롤뷰 델리게이트
extension OneViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        myLogPrint("사용자가 스크롤 동작 전")
        switch scrollView {
        case bannerScrollView:
            setupTimer(start: false)
            self.nowPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        default:
            ()
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        myLogPrint("사용자가 스크롤 동작 후")
        switch scrollView {
        case bannerScrollView:
            setupTimer(start: true)
        default:
            ()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case bannerScrollView:
            self.scrollPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
            // 스크롤 최대값 위치 확인
            let maxOffset = scrollView.contentSize.width - scrollView.frame.size.width
            // 스크롤 위치가 최대값(maxOffset)을 넘어가면 위치를 0으로 초기화 시킨다
            if scrollView.contentOffset.x >= maxOffset {
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
                self.nowPage = 1 //초기화
            }
        default:
            ()
        }
    }
}


//MARK: - 로케이션 델리게이트
extension OneViewController :CLLocationManagerDelegate{
    
    // 권한 확인하기
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined, .restricted, .denied:
            print("@@@@ 지도권한 notDetermined")
            requestHomeTap()
            
        case .authorizedAlways:
            print("@@@@ 지도권한 authorizedAlways")
        case .authorizedWhenInUse:
            print("@@@@ 지도권한 authorizedWhenInUse")
        case .authorized:
            print("@@@@ 지도권한 authorized")
        @unknown default:
            fatalError()
        }
    }
    
    
    // 현재좌표 받기
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else { return }

        AppConfig.defaultValue.myLat = first.coordinate.latitude
        AppConfig.defaultValue.myLng = first.coordinate.longitude
        
        // 이후의 코드는 최초 한번만 동작하기
        if self.locationNumber != 0{
            return
        }
        
        requestHomeTap()
        
        self.locationNumber += 1
    }
}
