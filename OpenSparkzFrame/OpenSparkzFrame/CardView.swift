//
//  CardView.swift
//  OpenSparkz
//
//  Created by apple on 07/02/22.
//

import UIKit


public protocol CardViewDelegate : AnyObject {
    func resultStatus(result : [String: Any]?)
    func networkStatus(status: Bool)
}



@available(iOS 11.0, *)
public class CardView: UIView, UITextFieldDelegate {
    
    var cardBannerView : UIView!
    var lblCardDetails : UILabel!
    var lblCardNumber : UILabel!
    var lblExpiry : UILabel!
    var cardNumberView: UIView!
    var expDateView: UIView!
    var textFieldCardNumber : ValidationTextField!
    var textFieldExpiry : ValidationTextField!
    var btnRegister : UIButton!
    var loadingIndicator : UIActivityIndicatorView!
    
    public weak var cardDeleagte : CardViewDelegate?
    
    @IBInspectable
    open var enableDefaultLoader: Bool = false
    {
        didSet{
        }
    }
    
    @IBInspectable
    open var configureGetAddCardEndPoint: String = "https://playground.app.opensparkz.net/api/card/getcardaddtoken"
    {
        didSet{
        }
    }
    
    @IBInspectable
    open var configureRegisterCardEndPoint: String = "https://playground.externalcard.opensparkz.net/api/registercard/registercard"
    {
        didSet{
        }
    }
    
    
    
    @IBInspectable
    open var activeBorderColor: UIColor = #colorLiteral(red: 0.9411764706, green: 0.3529411765, blue: 0.1568627451, alpha: 1)
    {
        didSet{
        }
    }
    
    @IBInspectable
    open var cardBackgroundColor: UIColor = #colorLiteral(red: 0.6549019608, green: 0.662745098, blue: 0.6705882353, alpha: 1) {
        didSet{
            self.cardBannerView.backgroundColor = cardBackgroundColor
        }
    }
    
    @IBInspectable
    open var defaultBorderColor: UIColor = #colorLiteral(red: 0.2470588235, green: 0.3058823529, blue: 0.3411764706, alpha: 1) {
        didSet{
            self.textFieldCardNumber.layer.borderColor = defaultBorderColor.cgColor
            self.textFieldExpiry.layer.borderColor = defaultBorderColor.cgColor
            self.cardBannerView.layer.borderColor = defaultBorderColor.cgColor
        }
    }
    
    
    @IBInspectable
    open var defaultEditTextColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet{
            textFieldCardNumber.textColor = defaultEditTextColor
            textFieldExpiry.textColor = defaultEditTextColor
        }
    }
    
    @IBInspectable
    open var defaultTextColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet{
            lblCardDetails.textColor = defaultTextColor
            lblCardNumber.textColor = defaultTextColor
            lblExpiry.textColor = defaultTextColor
        }
    }
    
    @IBInspectable
    open var errorTextColor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1) {
        didSet{
            self.textFieldCardNumber.errorColor = errorTextColor
            self.textFieldExpiry.errorColor = errorTextColor
        }
    }
    
    
    @IBInspectable
    open var fontFamily: UIFont = .systemFont(ofSize: 15) {
        didSet{
            lblCardNumber.font = fontFamily
            lblExpiry.font = fontFamily
            textFieldCardNumber.font = fontFamily
            textFieldExpiry.font = fontFamily
            lblCardDetails.font = fontFamily
        }
    }
    
    @IBInspectable
    open var cardNumberErrorMessage: String = MESSAGE.kCardNumberErrorMessage {
        didSet{
            self.textFieldCardNumber.errorMessage = cardNumberErrorMessage
        }
    }
    
    @IBInspectable
    open var cardExpiryErrorMessage: String = MESSAGE.kCardExpiryErrorMessage {
        didSet{
            self.textFieldExpiry.errorMessage = cardExpiryErrorMessage
        }
    }
    
    
    public override required init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        addBehavior()
    }
    
    
    private func addBehavior() {
    
        cardBannerView = UIView(frame: CGRect(x: 10, y: 10, width: self.frame.size.width - 20.0, height: self.frame.size.height - 20.0))
        cardBannerView.layer.borderColor = defaultBorderColor.cgColor
        cardBannerView.layer.borderWidth = 1.0
        cardBannerView.layer.masksToBounds = true
        cardBannerView.layer.cornerRadius = 8.0
        
        self.addSubview(cardBannerView)
        
        setUpCardBannerView()
        setUpLoaderView()
    }
    
    private func setUpCardBannerView()
    {
        lblCardDetails = UILabel(frame: CGRect(x: 20.0, y: 20.0, width: self.cardBannerView.frame.size.width - 40.0, height: 40.0))
        lblCardDetails.text = MESSAGE.kEnterCardDetails
        lblCardDetails.textAlignment = .left
        lblCardDetails.textColor = .darkGray
        
        lblCardNumber = UILabel(frame: CGRect(x: 20.0, y: lblCardDetails.frame.size.height + lblCardDetails.frame.origin.y, width: self.cardBannerView.frame.size.width - 40.0, height: 40.0))
        lblCardNumber.text = MESSAGE.kCardNumber
        lblCardNumber.textAlignment = .left
        lblCardNumber.textColor = .darkGray
        
        cardNumberView = UIView(frame: CGRect(x: 20.0, y: lblCardNumber.frame.size.height + lblCardNumber.frame.origin.y, width: self.cardBannerView.frame.size.width - 40.0, height: 40.0))
        
        textFieldCardNumber = ValidationTextField(frame: CGRect(x: 0, y: 0, width: self.cardBannerView.frame.size.width - 40.0, height: 40.0))
        textFieldCardNumber.layer.borderColor = defaultBorderColor.cgColor
        textFieldCardNumber.titleColor = .clear
        
        
        textFieldCardNumber.placeholder = MESSAGE.kCardNumberPlaceholder
        textFieldCardNumber.layer.borderWidth = 1.0
        textFieldCardNumber.layer.cornerRadius = 8.0
        textFieldCardNumber.errorColor = errorTextColor
        textFieldCardNumber.errorMessage = cardNumberErrorMessage
        
        textFieldCardNumber.keyboardType = .numberPad
        textFieldCardNumber.delegate = self
        textFieldCardNumber.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        textFieldCardNumber.addTarget(self, action: #selector(didBeginText(textField:)), for: .editingDidBegin)
        textFieldCardNumber.addTarget(self, action: #selector(didEndText(textField:)), for: .editingDidEnd)
        textFieldCardNumber.titleText = ""
        textFieldCardNumber.borderStyle = .roundedRect
        self.textFieldCardNumber.isValid = true
        
        cardNumberView.addSubview(textFieldCardNumber)
        
        lblExpiry = UILabel(frame: CGRect(x: 20.0, y: cardNumberView.frame.size.height + cardNumberView.frame.origin.y + 10.0 , width: self.cardBannerView.frame.size.width - 40.0, height: 40.0))
        lblExpiry.text = MESSAGE.kCardExpiry
        lblExpiry.textAlignment = .left
        lblExpiry.textColor = .darkGray
        
        
        expDateView = ValidationTextField(frame: CGRect(x: 20.0, y: lblExpiry.frame.size.height + lblExpiry.frame.origin.y, width: self.cardBannerView.frame.size.width - 40.0, height: 40.0))
        textFieldExpiry = ValidationTextField(frame: CGRect(x: 0, y: 0, width: self.cardBannerView.frame.size.width - 40.0, height: 40.0))
        textFieldExpiry.layer.borderColor = defaultBorderColor.cgColor
        textFieldExpiry.titleColor = .clear
        
        textFieldExpiry.placeholder = MESSAGE.kCardExpiryPlaceholder
        textFieldExpiry.layer.borderWidth = 1.0
        textFieldExpiry.layer.cornerRadius = 8.0
        textFieldExpiry.errorColor = errorTextColor
        textFieldExpiry.errorMessage = cardExpiryErrorMessage
        
        
        
        textFieldExpiry.keyboardType = .numberPad
        textFieldExpiry.delegate = self
        textFieldExpiry.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        textFieldExpiry.addTarget(self, action: #selector(didBeginText(textField:)), for: .editingDidBegin)
        textFieldExpiry.addTarget(self, action: #selector(didEndText(textField:)), for: .editingDidEnd)
        textFieldExpiry.titleText = ""
        textFieldExpiry.borderStyle = .roundedRect
        self.textFieldExpiry.isValid = true
        
        expDateView.addSubview(textFieldExpiry)
        
        cardBannerView.addSubview(lblCardDetails)
        cardBannerView.addSubview(lblCardNumber)
        cardBannerView.addSubview(lblExpiry)
        cardBannerView.addSubview(cardNumberView)
        cardBannerView.addSubview(expDateView)
        
        
    }
    
    private func setUpLoaderView()
    {
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0))
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        }
        loadingIndicator.color = .darkGray
        loadingIndicator.stopAnimating()
        loadingIndicator.center = CGPoint(x: self.frame.size.width  / 2,
                                     y: self.frame.size.height / 2)

        self.addSubview(loadingIndicator)
    }
    
    @objc private func didBeginText(textField:UITextField) {
        if(textField == self.textFieldCardNumber)
        {
            self.textFieldCardNumber.layer.borderColor = activeBorderColor.cgColor
        }
        else{
            self.textFieldExpiry.layer.borderColor = activeBorderColor.cgColor
        }
    }
    
    @objc private func didEndText(textField:UITextField) {
        textField.layer.borderColor = defaultBorderColor.cgColor
    }
    
    
    @objc private func didChangeText(textField:UITextField) {
        
        if(textField == textFieldCardNumber)
        {
            self.textFieldCardNumber.isValid = true
            textField.text = self.modifyCardString(creditCardString: textField.text!)
            
            if(textField.text?.count ?? 0 > 19)
            {
                textFieldCardNumber.deleteBackward()
            }
        }
        else{
            self.textFieldExpiry.isValid = true
            if(textField.text?.count ?? 0 < 5)
            {
                textField.text = self.modifyYearMonthString(monthYearString: textField.text!)
            }
            
            if(textField.text?.count ?? 0 > 5 || (textField.text?.count == 1 && ((textField.text! as NSString).integerValue > 1)) || (textField.text?.count == 2 && ((textField.text! as NSString).integerValue > 12 || (textField.text! as NSString).integerValue <  1)))
            {
                textFieldExpiry.deleteBackward()
            }
            
        }
        
        
    }
    
    private func modifyCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    private func modifyYearMonthString(monthYearString : String) -> String {
        let trimmedString = monthYearString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(self.removeSpecialCharsFromString(text: trimmedString))
        var modifiedMonthYearString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedMonthYearString.append(arrOfCharacters[i])
                if(i == 1 && i+1 != arrOfCharacters.count){
                    modifiedMonthYearString.append("/")
                }
            }
        }
        return modifiedMonthYearString
    }
    
    private func removeSpecialCharsFromString(text: String) -> String {
        let myNumbers = text.filter { "bcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".contains($0) }
        return myNumbers
    }
    
    
    private func validate() -> Bool {
        var isVerified = true
        if self.textFieldCardNumber.text!.isEmpty || self.textFieldCardNumber.text?.components(separatedBy: .whitespaces).joined().count != 16 {
            self.textFieldCardNumber.isValid = false
            self.textFieldCardNumber.validCondition = {$0.count > 19}
            self.textFieldCardNumber.checkValidation()
            isVerified = false
            
        }
        
        if self.textFieldExpiry.text!.isEmpty || self.removeSpecialCharsFromString(text: self.textFieldExpiry.text ?? "").count != 4{
            self.textFieldExpiry.isValid = false
            self.textFieldExpiry.validCondition = {$0.count > 5}
            self.textFieldExpiry.checkValidation()
            isVerified = false
        }
        
        return isVerified
    }
    
    private func showloader()
    {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.isUserInteractionEnabled = false
        }
    }
    
    private func hideLoader()
    {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.isUserInteractionEnabled = true
        }
    }
    
//    private func showAlert(message: String) {
//
//        DispatchQueue.main.async {
//            let parentViewController: UIViewController = UIApplication.shared.windows[1].rootViewController!
//
//            let alert = UIAlertController(title: APPNAME , message: message, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: MESSAGE.kOk, style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
//            }))
//            parentViewController.present(alert, animated: true, completion: nil)
//        }
//    }
    
    public func registerCard(accessToken: String)
    {
        self.endEditing(true)
        if(self.validate())
        {
            if Reachability.isConnectedToNetwork(){
            if(enableDefaultLoader)
            {
                self.showloader()
            }
            apiGetCardAddToken(accessToken: accessToken)
            }
            else
            {
                self.cardDeleagte?.networkStatus(status: false)
            }
        }
    }
    
    
}


@available(iOS 11.0, *)
extension CardView
{
    private func apiGetCardAddToken(accessToken: String)
    {
        let params = [String:Any]()
        
        ApiHelper.apiCallGet(serviceName: configureGetAddCardEndPoint, param: params, isWithToken: true, token: accessToken, showLoader: true) { result, error in
            if(error == nil)
            {
                DispatchQueue.main.async {
                    self.apiRegisterCard(customerToken: result?["token"] as? String ?? "")
                }
            }
            else
            {
                self.hideLoader()
            }
            
            
        }
    }
    
    private func apiRegisterCard(customerToken : String)
    {
        var params = [String:Any]()
        params["cardnumber"] = textFieldCardNumber.text?.components(separatedBy: .whitespaces).joined()
        params["expiry"] = self.removeSpecialCharsFromString(text:self.textFieldExpiry.text ?? "")
        
        ApiHelper.apiCallPost(serviceName: configureRegisterCardEndPoint, param: params, isWithToken: true, token: customerToken, showLoader: true) { result, error in
            self.hideLoader()
            if(error == nil)
            {
                self.cardDeleagte?.resultStatus(result: result!)
            }
            else{
                self.cardDeleagte?.resultStatus(result: nil)
            }
        }
    }
    
}

