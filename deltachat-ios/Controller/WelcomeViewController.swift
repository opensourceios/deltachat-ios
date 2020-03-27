import UIKit

class WelcomeViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var welcomeView: WelcomeContentView = {
        let view = WelcomeContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        welcomeView.minContainerHeight = view.frame.height
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        welcomeView.minContainerHeight = size.height
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    // MARK: - setup
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(welcomeView)

        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide

        frameGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        frameGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        frameGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        frameGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        contentGuide.leadingAnchor.constraint(equalTo: welcomeView.leadingAnchor).isActive = true
        contentGuide.topAnchor.constraint(equalTo: welcomeView.topAnchor).isActive = true
        contentGuide.trailingAnchor.constraint(equalTo: welcomeView.trailingAnchor).isActive = true
        contentGuide.bottomAnchor.constraint(equalTo: welcomeView.bottomAnchor).isActive = true

        frameGuide.widthAnchor.constraint(equalTo: contentGuide.widthAnchor).isActive = true
    }
}


class WelcomeContentView: UIView {

    var onLogin: VoidFunction?
    var onScanQRCode: VoidFunction?
    var onImportBackup: VoidFunction?

    var minContainerHeight: CGFloat = 0 {
        didSet {
            containerMinHeightConstraint.constant = minContainerHeight
            logoHeightConstraint.constant = calculateLogoHeight()
        }
    }

    private lazy var containerMinHeightConstraint: NSLayoutConstraint = {
        return container.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
    }()

    private lazy var logoHeightConstraint: NSLayoutConstraint = {
        return logoView.heightAnchor.constraint(equalToConstant: 0)
    }()

    private var container = UIView()

    private var logoView: UIImageView = {
        let image = #imageLiteral(resourceName: "ic_launcher").withRenderingMode(.alwaysOriginal)
        let view = UIImageView(image: image)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Delta Chat "
        label.textColor = DcColors.grayTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "The messenger with the broadest audience in the world. Free and independent."
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = DcColors.grayTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        let title = "log in to your server".uppercased()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = DcColors.primary
        let insets = button.contentEdgeInsets
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var qrCodeButton: UIButton = {
        let button = UIButton()
        let title = "Scan QR code"
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(qrCodeButtonPressed(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var importBackupButton: UIButton = {
        let button = UIButton()
        let title = "Import backup"
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(importBackupButtonPressed(_:)), for: .touchUpInside)
        return button
    }()

    private let defaultSpacing: CGFloat = 20

    init() {
        super.init(frame: .zero)
        setupSubviews()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setup
    private func setupSubviews() {
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        container.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true

        containerMinHeightConstraint.isActive = true

        _ = [logoView, titleLabel, subtitleLabel, loginButton, qrCodeButton, importBackupButton].map {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let bottomLayoutGuide = UILayoutGuide()
        container.addLayoutGuide(bottomLayoutGuide)
        bottomLayoutGuide.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        bottomLayoutGuide.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.55).isActive = true

        subtitleLabel.topAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -defaultSpacing).isActive = true
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        logoView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -defaultSpacing).isActive = true
        logoView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        logoHeightConstraint.constant = calculateLogoHeight()
        logoHeightConstraint.isActive = true
        logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor).isActive = true

        let logoTopAnchor = logoView.topAnchor.constraint(equalTo: container.topAnchor, constant: 20)   // this will make container bigger if needed
        logoTopAnchor.priority = .defaultLow
        logoTopAnchor.isActive = true

        loginButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: defaultSpacing).isActive = true

        qrCodeButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: defaultSpacing).isActive = true
        qrCodeButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        importBackupButton.topAnchor.constraint(equalTo: qrCodeButton.bottomAnchor, constant: 10).isActive = true
        importBackupButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        importBackupButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        let importBackupButtonConstraint = importBackupButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -50)
        importBackupButtonConstraint.priority = .defaultLow
        importBackupButtonConstraint.isActive = true

    }

    private func calculateLogoHeight() -> CGFloat {
        let titleHeight = titleLabel.intrinsicContentSize.height
        let subtitleHeight = subtitleLabel.intrinsicContentSize.height
        let intrinsicHeight = subtitleHeight + titleHeight
        let maxHeight: CGFloat = 100
        return intrinsicHeight > maxHeight ? maxHeight : intrinsicHeight
    }

    // MARK: - actions
     @objc private func loginButtonPressed(_ sender: UIButton) {
         onLogin?()
     }

     @objc private func qrCodeButtonPressed(_ sender: UIButton) {
         onScanQRCode?()
     }

     @objc private func importBackupButtonPressed(_ sender: UIButton) {
         onImportBackup?()
     }
}