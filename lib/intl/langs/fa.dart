import 'package:jozapp_flutter/models/types.dart';

const Json fa = {
  "main.profile": "پروفایل",
  "main.wallet": "کیف پول",
  "main.services": "خدمات",
  "main.trans": "تاریخچه",
  "cur.iqd.s": "دینار",
  "cur.iqd.l": "دینار عراق",
  "cur.iqd.sym": "دینار",
  "cur.irr.s": "ریال",
  "cur.irr.l": "ریال",
  "cur.irr.sym": "ریال",
  "cur.aud.s": "دلار",
  "cur.aud.l": "دلار استرالیا",
  "cur.aud.sym": "\$",
  "cur.usd.s": "دلار",
  "cur.usd.l": "دلار آمریکا",
  "cur.usd.sym": "\$",
  "cur.eur.s": "یورو",
  "cur.eur.l": "یورو",
  "cur.eur.sym": "€",
  "cur.gbp.s": "پوند",
  "cur.gbp.l": "پوند انگلیس",
  "cur.gbp.sym": "£",
  "cur.aed.s": "درهم",
  "cur.aed.l": "درهم امارات",
  "cur.aed.sym": "AED",
  "cur.cad.s": "دلار",
  "cur.cad.l": "دلار کانادا",
  "cur.cad.sym": "\$",
  "cur.try.s": "لیر",
  "cur.try.l": "لیر ترکیه",
  "cur.try.sym": "₺",
  "cur.cny.s": "یوان",
  "cur.cny.l": "یوان چین",
  "cur.cny.sym": "یوان",
  "OrderStatus.issued": "باز",
  "OrderStatus.accepted": "پذیرفته شده",
  "OrderStatus.rejected": "رد شده",
  "OrderStatus.canceled": "کنسل شده",
  "OrderStatus.suspended": "معلق شده",
  "OrderStatus.issued.s": "باز",
  "OrderStatus.accepted.s": "پذ",
  "OrderStatus.rejected.s": "رد",
  "OrderStatus.canceled.s": "ک",
  "OrderStatus.suspended.s": "مع",
  "OrderTypes.all2.s": "همه",
  "OrderTypes.topUp.s": "وا",
  "OrderTypes.withdraw.s": "بر",
  "OrderTypes.exchange.s": "مب",
  "OrderTypes.transfer.s": "ان",
  "OrderTypes.fee.s": "نرخ",
  "OrderTypes.All.l": "(همه)",
  "OrderTypes.airplaneTicket.s": "بلیط",
  "OrderTypes.otp.s": "یکبار رمز",
  "OrderTypes.all2.l": "همه",
  "OrderTypes.topUp.l": "واریز وجه",
  "OrderTypes.withdraw.l": "برداشت وجه",
  "OrderTypes.exchange.l": "مبادله ارز",
  "OrderTypes.transfer.l": "انتقال",
  "OrderTypes.fee.l": "نرخ",
  "OrderTypes.airplaneTicket.l": "بلیط هواپیما",
  "OrderTypes.otp.l": "یکبار رمز",
  "auth.forget_pass": "فراموشی کلمه عبور",
  "auth.contact_us": "ارتباط با ما",
  "profile.your_wallet": "کیف پول شما",
  "profile.about_us": "درباره ما",
  "profile.change_password": "تغییر کلمه عبور",
  "profile.user_settings": "تنظیمات کاربری",
  "profile.change_lang": "زبان",
  "profile.branch_info": "اطلاعات شعبه",
  "profile.logout": "خروج",
  "login": "ورود",
  "register": "ثبت نام",
  "auth.phone_number": "شماره تلفن",
  "auth.password": "کلمه عبور",
  "auth.confirm": "تکرار کلمه عبور",
  "auth.curPassword": "کلمه عبور فعلی",
  "auth.newPassword": "کلمه عبور جدید",
  "auth.displayName": "نام",
  "auth.logout": "خروج",
  "auth.code": "کد ارزیابی",
  "auth.verify_code": "ارزیابی کد",
  "auth.register_user": "ایجاد کاربر",
  "auth.user_information": "اطلاعات کاربر",
  "auth.set_new_password": "تنظیم کلمه عبور جدید",
  "auth.set_password": "تنظیم کلمه عبور",
  "auth.enter_ver_code": "کد ارزیابی دریافت شده را وارد کنید",
  "auth.send_sms": "ارسال پیامک",
  "auth.select_branch": "انتخاب شعبه",
  "auth.no_branch": "شعبه ای وجود ندارد",
  "err.userAlreadyExist": "کاربری با این شماره تلفن هم اکنون وجود دارد",
  "err.userNotExist": "کاربری با این شماره تلفن وجود ندارد",
  "err.sendingVerificationCode": "خطا در ارسال کد ارزیابی",
  "err.verifyVerificationCode": "کد ارزیابی معتبر نمیباشد",
  "err.invalid_phone": "شماره تلفن معتبر نیست",
  "err.invalid_password": "کلمه عبور معتبر نیست",
  "err.tooShortVerifyCode": "کد ارزیابی خیلی کوتاه است",
  "err.displayName": "نام وارد شده کوتاه است",
  "err.passwords_match": "کلمات عبور وارد شده یکسان نیستند",
  "err.set_password": "خطایی در تنظیم کلمه عبور رخ داده است",
  "main.services.choice.service": "سرویسهای قابل ارایه",
  "OrderTypes.topUp.t": "سرویس واریز وجه",
  "OrderTypes.topUp.ts": "انتخاب جهت واریز وجه",
  "OrderTypes.withdraw.t": "سرویس برداشت وجه",
  "OrderTypes.withdraw.ts": "انتخاب جهت برداشت وجه",
  "OrderTypes.transfer.t": "سرویس انتقال وجه",
  "OrderTypes.transfer.ts": "انتخاب جهت انتقال وجه",
  "Back": "برگشت",
  "Next": "بعدی",
  "Cancel": "لغو",
  "Confirm": "تایید",
  "err.invalid_amount": "مبلغ غیر معتبر",
  "err.invalid_wallet_number": "شماره کیف پول وارد شده معتبر نیست",
  "err.insufficient_liquidity": "موجودی کافی نیست",
  "amount": "مبلغ {0}",
  "available": "موجودی {0}",
  "profile.wallet_number": "شماره کیف پول",
  "q.do_that": "آیا از انجام این کار اطمینان دارید؟",
  "q.cancel": "آیا از لغو این کار اطمینان دارید؟",
  "q.cancel_order": "آیا از لغو این سفارش اطمینان دارید؟",
  "msg.order_canceled": "سفارش با موفقیت لغو شد",
  "orders.open": "سفارشهای باز",
  "successfully": "موفقیت آمیز بود!",
  "msg.set_password_was": "تنظیم کلمه عبور",
  "msg.ticket_issue": "صدور بلیط",
  "msg.user_creation": "ایجاد کاربر",
  "msg.change_password": "تغییر کلمه عبور",
  "msg.your_operation": "عملیات {0}",
  "txt.dest_cur": "ارز مقصد {0}",
  "Yes": "آری",
  "No": "خیر",
  "Question": "پرسش",
  "txt.load_more": "بیشتر ...",
  "order.type": "نوع سفارش",
  "order.amount": "مبلغ سفارش",
  "order.issue_date": "تاریخ ایجاد",
  "order.view": "مشاهده سفارش",
  "profile.welcome": "{0} خوش آمدید",
  "profile.current_balance": "موجودی فعلی",
  "profile_def_currency": "ارز پیش فرض",
  "profile.address": "آدرس",
  "profile.phone": "شماره تلفن",
};