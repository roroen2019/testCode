//
//  MVVM3ViewController.swift
//  testView
//
//  Created by myPuppy on 2023/06/07.
//
/*
 raywenderlich mvvm 튜토리얼
 */
import UIKit

//MARK: - viewController
class MVVM3ViewController: UIViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let birthday = Date(timeIntervalSinceNow: (-2 * 86400 * 366))
        let image = UIImage(systemName: "person")!
        let stuart = Pet(name: "Stuart",
                         birthday: birthday,
                         rarity: .veryRare,
                         image: image)

        // 2
        let viewModel = PetViewModel(pet: stuart)

        // 3
        let frame = CGRect(x: 0, y: 0, width: 300, height: 420)
        let petview = PetView(frame: frame)
        
        // 4
        petview.nameLabel.text = viewModel.name
        petview.imageView.image = viewModel.image
        petview.ageLabel.text = viewModel.ageText
        petview.adoptionFeeLabel.text = viewModel.adoptionFeeText

        // 5
        view.addSubview(petview)
        
    }
    
    
}

//MARK: - Model
/*
 이동할 데이터 모음
 */
public class Pet {
    public enum Rarity {
        case common
        case uncommon
        case rare
        case veryRare
    }
    
    public let name: String
    public let birthday: Date
    public let rarity: Rarity
    public let image: UIImage
    
    public init(name: String,
                birthday: Date,
                rarity: Rarity,
                image: UIImage) {
        self.name = name
        self.birthday = birthday
        self.rarity = rarity
        self.image = image
    }
}

// MARK: - ViewModel
/*
 
 */
public class PetViewModel {
    
    // 1
    private let pet: Pet
    private let calendar: Calendar
    
    public init(pet: Pet) {
        self.pet = pet
        self.calendar = Calendar(identifier: .gregorian)
    }
    
    // 2 모델의 값을 리턴한다.
    public var name: String {
        return pet.name
    }
    
    public var image: UIImage {
        return pet.image
    }
    
    // 3 값을 전처리후 리턴
    public var ageText: String {
        let today = calendar.startOfDay(for: Date())
        let birthday = calendar.startOfDay(for: pet.birthday)
        let components = calendar.dateComponents([.year],
                                                 from: birthday,
                                                 to: today)
        let age = components.year!
        return "\(age) years old"
    }
    
    // 4
    public var adoptionFeeText: String {
        switch pet.rarity {
        case .common:
            return "$50.00"
        case .uncommon:
            return "$75.00"
        case .rare:
            return "$150.00"
        case .veryRare:
            return "$500.00"
        }
    }
}

/*
 뷰모델에서 뷰의 값을 설정한다.
 */
extension PetViewModel {
    public func configure(_ view: PetView) {
        view.nameLabel.text = name
        view.imageView.image = image
        view.ageLabel.text = ageText
        view.adoptionFeeLabel.text = adoptionFeeText
    }
}



// MARK: - View
public class PetView: UIView {
    public let imageView: UIImageView
    public let nameLabel: UILabel
    public let ageLabel: UILabel
    public let adoptionFeeLabel: UILabel
    
    public override init(frame: CGRect) {
        
        var childFrame = CGRect(x: 0, y: 16,
                                width: frame.width,
                                height: frame.height / 2)
        imageView = UIImageView(frame: childFrame)
        imageView.contentMode = .scaleAspectFit
        
        childFrame.origin.y += childFrame.height + 16
        childFrame.size.height = 30
        nameLabel = UILabel(frame: childFrame)
        nameLabel.textAlignment = .center
        
        childFrame.origin.y += childFrame.height
        ageLabel = UILabel(frame: childFrame)
        ageLabel.textAlignment = .center
        
        childFrame.origin.y += childFrame.height
        adoptionFeeLabel = UILabel(frame: childFrame)
        adoptionFeeLabel.textAlignment = .center
        
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(adoptionFeeLabel)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}
