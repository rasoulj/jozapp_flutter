import 'package:jozapp_flutter/models/types.dart';

const Json ar = {
  "main.profile": "ملفي",
  "main.wallet": "محفظتى",
  "main.services": "خدماتي",
  "main.trans": "المعاملات",
  "cur.iqd.s": "الدينار العراقي",
  "cur.iqd.l": "الدينار العراقي",
  "cur.iqd.sym": "الدينار العراقي",
  "cur.irr.s": "ريال ايراني",
  "cur.irr.l": "ريال ايراني",
  "cur.irr.sym": "IRR",
  "cur.aud.s": "دولار أسترالي",
  "cur.aud.l": "دولار استرالي",
  "cur.aud.sym": "\$",
  "cur.usd.s": "دولار أمريكي",
  "cur.usd.l": "الدولار الأمريكي",
  "cur.usd.sym": "\$",
  "cur.eur.s": "يورو",
  "cur.eur.l": "اليورو",
  "cur.eur.sym": "€",
  "cur.gbp.s": "GBP",
  "cur.gbp.l": "الباون البريطانية",
  "cur.gbp.sym": "جنيه استرليني",
  "cur.aed.s": "درهم إماراتي",
  "cur.aed.l": "درهم إماراتي",
  "cur.aed.sym": "AED",
  "cur.cad.s": "CAD",
  "cur.cad.l": "دولار كندي",
  "cur.cad.sym": "\$",
  "cur.try.s": "TRY",
  "cur.try.l": "Turkish Lira",
  "cur.try.sym": "₺",
  "cur.cny.s": "Yuan",
  "cur.cny.l": "China Yuan",
  "cur.cny.sym": "CNY",
  "OrderStatus.issued": "افتح",
  "OrderStatus.accepted": "قبول",
  "OrderStatus.rejected": "مرفوض",
  "OrderStatus.canceled": "إلغاء",
  "OrderStatus.suspended": "معلق",
  "OrderStatus.issued.s": "ف",
  "OrderStatus.accepted.s": "ق",
  "OrderStatus.rejected.s": "ر",
  "OrderStatus.canceled.s": "إ",
  "OrderStatus.suspended.s": "م",
  "OrderTypes.all2.s": "الكل",
  "OrderTypes.topUp.s": "TU",
  "OrderTypes.withdraw.s": "W",
  "OrderTypes.exchange.s": "E",
  "OrderTypes.transfer.s": "T",
  "OrderTypes.fee.s": "F",
  "OrderTypes.All.l": "(جميع أنواع الطلبات)",
  "OrderTypes.airplaneTicket.s": "",
  "OrderTypes.otp.s": "",
  "OrderTypes.all2.l": "الكل",
  "OrderTypes.topUp.l": "ايداع",
  "OrderTypes.withdraw.l": "سحب",
  "OrderTypes.exchange.l": "تصريف",
  "OrderTypes.transfer.l": "حواله",
  "OrderTypes.fee.l": "الرسوم",
  "OrderTypes.airplaneTicket.l": "تذكرة طيران",
  "OrderTypes.otp.l": "كلمة السر لمرة واحدة",
  "auth.forget_pass": "هل نسيت كلمة السر",
  "auth.contact_us": "اتصل بنا",
  "profile.your_wallet": "رقم محفظتك",
  "profile.about_us": "معلومات عنا",
  "profile.change_password": "غير كلمة السر",
  "profile.user_settings": "إعدادات المستخدم",
  "profile.change_lang": "لغة",
  "profile.branch_info": "معلومات الفرع",
  "profile.logout": "خروج",
  "login": "تسجيل الدخول",
  "register": "تسجيل",
  "auth.phone_number": "رقم الهاتف",
  "auth.password": "كلمة المرور",
  "auth.confirm": "تأكيد كلمة المرور",
  "auth.curPassword": "كلمة المرور الحالية",
  "auth.newPassword": "كلمة السر الجديدة",
  "auth.displayName": "اسم العرض",
  "auth.logout": "خروج",
  "auth.code": "رمز التحقق",
  "auth.verify_code": "التحقق من كود",
  "auth.register_user": "تسجيل المستخدم",
  "auth.user_information": "معلومات المستخدم",
  "auth.set_new_password": "تعيين كلمة مرور جديدة",
  "auth.set_password": "نعیین كلمة السر",
  "auth.enter_ver_code": "أدخل رمز التحقق الذي تلقيته",
  "auth.send_sms": "أرسل رسالة نصية قصيرة",
  "auth.select_branch": "حدد الفرع",
  "auth.no_branch": "لا يوجد فرع",
  "err.userAlreadyExist": "مستخدم بهذه رقم الهاتف موجود",
  "err.userNotExist": "لم يتم العثور على مستخدم بهذه رقم الهاتف",
  "err.sendingVerificationCode": "خطأ في إرسال رمز التحقق",
  "err.verifyVerificationCode": "رمز التحقق غير صالح.",
  "err.invalid_phone": "رقم الهاتف غير صحيح",
  "err.invalid_password": "رمز مرور خاطئ",
  "err.tooShortVerifyCode": "رمز التحقق الذي تم إدخاله قصير جدًا",
  "err.displayName": "اسم العرض قصير جدًا",
  "err.passwords_match": "كلمات المرور المدخلة غير متطابقة",
  "err.set_password": "حدث خطأ في تعيين كلمة مرور جديدة",
  "main.services.choice.service": "الخدمات المتاحة",
  "OrderTypes.topUp.t": "خدمة إيداع الأموال",
  "OrderTypes.topUp.ts": "اختر اتجاه الإيداع",
  "OrderTypes.withdraw.t": "خدمة السحب",
  "OrderTypes.withdraw.ts": "اختر طريقة السحب",
  "OrderTypes.transfer.t": "خدمة تحويل الأموال",
  "OrderTypes.transfer.ts": "اختر اتجاه تحويل الأموال",
  "Back": "يعود",
  "Next": "التالي",
  "Cancel": "إلغاء",
  "Confirm": "التأكيد",
  "err.invalid_amount": "مبلغ غير صحيح",
  "err.invalid_wallet_number": "رقم المحفظة غير صالح",
  "err.insufficient_liquidity": "سيولة غير كافية",
  "amount": "المبلغ {0}",
  "available": "الأسهم {0}",
  "profile.wallet_number": "رقم المحفظة",
  "q.do_that": "هل أنت متأكد من القيام بذلك؟",
  "q.cancel": "هل أنت متأكد من إلغاء هذا الإجراء؟",
  "q.cancel_order": "هل أنت متأكد من إلغاء هذا الطلب؟",
  "msg.order_canceled": "تم إلغاء الطلب بنجاح",
  "orders.open": "افتح الطلبات",
  "successfully": "ناجح !",
  "msg.set_password_was": "تعيين كلمة المرور كان",
  "msg.ticket_issue": "إصدار التذكرة",
  "msg.user_creation": "إنشاء المستخدم الخاص بك كان",
  "msg.change_password": "تغيير كلمة المرور كان",
  "msg.your_operation": "{0} الخاص بك كان",
  "txt.dest_cur": "عملة الوجهة {0}",
  "Yes": "نعم",
  "No": "لا",
  "Question": "سؤال",
  "txt.load_more": "تحميل المزيد",
  "order.type": "نوع الطلب",
  "order.amount": "كمية الطلب",
  "order.issue_date": "تاريخ الإصدار",
  "order.view": "عرض الطلب",
  "profile.welcome": "مرحبًا {0}",
  "profile.current_balance": "الرصيد الحالي",
  "profile_def_currency": "العملة الافتراضية",
  "profile.address": "عنوان",
  "profile.phone": "هاتف",};