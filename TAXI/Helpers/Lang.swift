// بسم الله الرحمن الرحيم
//  Created by rakhmatillo topiboldiev on 10/03/21
//

import UIKit

final class Lang {
    init() {}
    
    static func getString(type: StringType) -> String {
        
        let lang = UserDefaults.standard.string(forKey: CONSTANTS.APP_LANGUAGE) ?? "ru"
        
        if lang == "en" {
            //English
            return StringEn.getString(forType: type)
        } else
        if lang == "ru" {
            //Russian
            return StringRu.getString(forType: type)
        } else {
            //Uzbek for default value
            return StringUz.getString(forType: type)
        }
        
    }
    
    enum StringType {
        //Mixed
        case agree_lbl
        case agree_attributed
        //mainView
        case l_where_r_u_going
        case l_top_label_in_main_view
        case l_top_subtitle_main_view
        case b_next
        
        //menuView
        case l_home
        case l_ride_history
        case l_settings
        case l_log_out
        
        case b_refer_friend
        case b_view_profile
        
        //referFirendView
        case l_refer_friend
        case l_refer_friend_desc
        case l_share_refferal_code
        case l_share_by_text
        case l_share_by_email
        case l_share_by_facebook
        case l_share_by_other_way
        case l_message_about_sharing_refferal_code
        
        //profileView
        case l_profile
        case l_firstname
        case l_lastname
        case l_phone_number
        
        case b_update
        
        
        //findCarView
        case l_sum
        case l_options
       
        case cash
        case l_i_will_tell_the_driver
        case b_entrance
        case b_create_ride
        case l_from
        
        //RideOptionsView
        case l_ride_options
        case l_air_conditioner
        case l_comment
        
        case b_done
        
        
        //CommentsView
        case p_enter_comment
        
        case l_comment_1
        case l_comment_2
        case l_comment_3
        case l_comment_4
        case l_comment_5
        case l_comment_6
        
        
        
        
        
        //LookingForCarsView
        case l_searching
        case l_searching_desc
        case l_cancel_order
        case l_one_more_car
        
        
        //PreCancelledAlertView
        case a_preCancelled_alert_title
        
        case a_b_retry
        case a_b_cancel
        
        //Simple Alert View
        case a_simple_alert_title
        case a_simple_alert_desc
        
        //Logout alert view
        case log_out_alert_title
        case log_out_alert_desc
        case a_b_ok
        
        //System alert
        // case a_system_title
        
        
        //Settings View
        case user_setting
        case others
        
        case profile
        case wallet
        case language
        case request_support
        case privacy_policy
        case terms_conditions
        case faq
        case about_us
        
        
        //Order details view
        case cost_of_your_ride
        case order_details
        
        //PAyment view
        case l_choose_payment_type
        case b_add_card
        
        //request and support
        case request_view_title
        case request_view_detail
        case request_submit
        
        //registe view
        case b_register
        case b_already_have_an_account
        
        //login view
        case login
        
        //otp view
        case b_verify
        
        
        //rate ride view
        
        case l_how_was_ride
        case l_comfortable_drive
        case l_great_navigation
        case l_clean
        case l_smooth_drive
        case l_you_have_arrived_at_your_destination
        
        case l_excellent
        case l_very_good
        case l_good
        case l_not_bad
        case l_awful
        
        //searchView
        case map
        case where_from
        case where_to
        
        //arriving view
        case arriving_mins
        case car_details
        
        case how_is_going_ride
        
        case call
        case chat
        case i_am_coming
        case cancel_ride
        case share_route
        case safety
        
        //order details view
        case driver_info
        case route
        case time
        case payment
        
        //safety view
        case trusted_contacts
        case emergency_call
        case ambulance_police
        
        
        case coming_soon
        case driver_is_here
        case chat_with_driver
        
        
        
        //
        case too_many_attempts
        case unknown_error_occured
        case no_internet_connection
        case validation_error
        case invalid_phone_number
        case code_does_not_match
        case code_expired
        case rider_not_found
        case couldnt_send_sms
        case user_already_exist
        case user_not_found
        case car_class_not_found
        case thanks_for_rating
        case driver_not_found
        case no_enough_permission
        case succesfully_updated
        
        
        case entrance
        case p_enter_entrance_number
        
        //
        case card_number
        case expire_date
        case card_number_placeholder
        case expire_date_placeholder
        
        case card_not_found
        case card_not_found_in_rider
        case please_fill_the_fields
        case card
        case enter_rider_phone_number
        case order_for_someone
        case succesfully_deleted_card
        case do_u_want_to_delete_card
        case delete
        
        
        case greeting
        case dear_user
        
        case start_price
        case waiting_time
        case per_km_value
        case km
        case per_minute_value
        case minute
        case mins
        case suburb
        case in_ride_waiting
        
        
        
        case sender_and_reciever
        case pickup_location
        case package_sender
        case apartment_office
        case floor
        case door_phone
        case comments
        case delivery_destination
        case package_recipient
        case door_to_door
        case order
        
        case please_choose_dest_address
        
        case me
        case please_choose_recipient_info
        
        case check_entered_info
        case please_resign
    }
    
    
    
}


extension Lang {
    
    //MARK: - Uzbek
    struct StringUz {
        static func getString(forType: StringType) -> String {
            switch forType {
            
            case .l_where_r_u_going:
                return "Qayerga boramiz?"
            case .l_top_label_in_main_view:
                return "Boshlang'ich manzil"
            case .l_top_subtitle_main_view:
                return "Aniqlanmoqda..."
            case .b_next:
                return "Keyingi"
            case .l_home:
                return "Asosiy"
            case .l_ride_history:
                return "Safarlar"
            case .l_settings:
                return "Sozlamalar"
            case .l_log_out:
                return "Chiqish"
            case .b_refer_friend:
                return "Do'stingiz bilan ulashish"
            case .b_view_profile:
                return "Profilni ko'rish"
            case .l_refer_friend:
                return "Do'stingiz bilan ulashish"
            case .l_refer_friend_desc:
                return "Do'stingizga ulashing, ular sizning promo-kodingizdan foydalangan holda chegirmalarga ega bo'lishadi va sizga chegirmalar taqdim etiladi."
            case .l_share_refferal_code:
                return "Sizning promo-kodingiz:"
            case .l_share_by_text:
                return "SMS xabar orqali ulashish"
            case .l_share_by_email:
                return "Elelktron pochta orqali ulashish"
            case .l_share_by_facebook:
                return "Facebook orqali ulashish"
            case .l_share_by_other_way:
                return "Boshqa ilovalar orqali ulashish"
            case .l_message_about_sharing_refferal_code:
                return "Bu mening Dyod taksidagi promo-kodim, promo-koddan foydalaning va chegirmaga ega bo'ling. "
            case .l_profile:
                return "Profil"
            case .l_firstname:
                return "Ism"
            case .l_lastname:
                return "Familya"
            case .l_phone_number:
                return "Telefon raqam"
            case .b_update:
                return "Yangilash"
            case .l_sum:
                return "so'm"
            case .l_options:
                return "Qo'shimcha"
                
            
            case .b_entrance:
                return "Podyezd"
            case .b_create_ride:
                return "Buyurtma berish"
            case .l_i_will_tell_the_driver:
                return "Haydovchiga manzilni aytaman"
            case .l_ride_options:
                return "Safar optsiyalari"
            case .l_air_conditioner:
                return "Konditsioner"
            case .l_comment:
                return "Izoh"
            case .b_done:
                return "Bajarildi"
            case .p_enter_comment:
                return "Izoh"
            case .l_comment_1:
                return "Qo'ng'iroq qilinmasin!"
            case .l_comment_2:
                return "Yuklarim uchun yordam kerak."
            case .l_comment_3:
                return "Kelishdan oldin qo'ng'iroq qiling."
            case .l_comment_4:
                return "Men avtobus bekatda kutib turibman."
            case .l_comment_5:
                return "Shoshilyapman, tezroq keling!"
            case .l_comment_6:
                return "Juda ham toliqqanman, orqa o'rindiqda ozgina dam olmoqchiman."
            case .l_searching:
                return "Qidirilmoqda"
            case .l_searching_desc:
                return "Bir qancha mashinalar mavjud. Sizga eng yaqin joylashganini tanlanmoqda"
            case .l_cancel_order:
                return "Bekor qilish"
            case .l_one_more_car:
                return "Yana bitta mashina"
            case .a_preCancelled_alert_title:
                return "Kechirasiz ☹️, sizning buyurtmangiz hech qanday haydovchi tomonidan qabul qilinmadi"
            case .a_b_retry:
                return "Qayta urinish"
            case .a_b_cancel:
                return "Bekor qilish"
            case .a_simple_alert_title:
                return "Safarni bekor qilish"
            case .a_simple_alert_desc:
                return "Buyurtma bekor qilinsinmi?"
            case .user_setting:
                return "Mening ma'lumotlarim"
            case .others:
                return "Boshqa"
            case .profile:
                return "Profil"
            case .wallet:
                return "Hamyon"
            case .language:
                return "Til"
            case .request_support:
                return "Yordam so'rash"
            case .privacy_policy:
                return "Mahfiylik siyosati"
            case .terms_conditions:
                return "Foydalanish qoidalari"
            case .faq:
                return "Ko'p so'raladigan savollar"
            case .about_us:
                return "Biz haqimizda"
                
            case .log_out_alert_title:
                return "Dasturdan chiqishni xohlaysizmi"
            case .log_out_alert_desc:
                return "Tez orada qaytishingizni intizorlik bilan kutamiz"
            case .a_b_ok:
                return "Ha"
                
            case .cash:
                return "Naqd"
                
            case .cost_of_your_ride:
                return "Sizdan "
            case .l_from:
                return "~"
            case .l_choose_payment_type:
                return "To'lov turini tanlang"
            case .b_add_card:
                return "Yangi karta qo'shish"
            case .request_view_title:
                return "Mavzu"
            case .request_view_detail:
                return "Tafsilotlar"
            case .request_submit:
                return "Yuborish"
            case .b_register:
                return "Ro'yxatdan o'tish"
            case .b_already_have_an_account:
                return "Avval ro'yxatdan o'tganmisiz?"
            case .login:
                return "Kirish"
            case .b_verify:
                return "Tasdiqlash"
                
            case .l_how_was_ride:
                return "Safaringiz qanday kechdi?"
            case .l_comfortable_drive:
                return "Qulay safar"
            case .l_great_navigation:
                return "Ajoyib navigatsiya"
            case .l_clean:
                return "Pokiza avtomobil"
            case .l_smooth_drive:
                return "Tekis haydash"
            case .l_you_have_arrived_at_your_destination:
                return "Yetib keldingiz"
            case .l_excellent:
                return "Ajoyib"
            case .l_very_good:
                return "Juda yaxshi"
            case .l_good:
                return "Yaxshi"
            case .l_not_bad:
                return "Qoniqarli"
            case .l_awful:
                return "Qoniqarsiz"
            case .map:
                return "Harita"
            case .where_from:
                return "Qayerdan"
            case .where_to:
                return "Qayerga"
                
            case .order_details:
                return "Buyurtma ma'lumotlari"
            case .arriving_mins:
                return "Yetib kelish vaqti:"
            case .car_details:
                return "Mashina haqida"
            case .how_is_going_ride:
                return "Safaringiz qanday kechyapti?"
            case .call:
                return "Qo'ng'iroq qilish"
            case .chat:
                return "Chat"
            case .i_am_coming:
                return "Kelyapman"
            case .cancel_ride:
                return "Bekor qilish"
            case .share_route:
                return "Yo'lni ulashish"
            case .safety:
                return "Xavfsizlik"
            case .driver_info:
                return "Haydovchi"
            case .route:
                return "Yo'l"
            case .time:
                return "Vaqt"
            case .payment:
                return "To'lov turi"
            case .trusted_contacts:
                return "Ishonchli kontakt"
            case .emergency_call:
                return "Favqulodda chaqiruv"
            case .ambulance_police:
                return "Tez yordam va militsiya"
                
            case .coming_soon:
                return "Tez orada ishga tushadi"
            case .driver_is_here:
                return "Haydovchi sizni kutyapti"
            case .chat_with_driver:
                return "Haydovchi bilan yozishma"
                
            case .too_many_attempts:
                return "Ko'p urinish sodir bo'ldi, bir ozdan so'ng urinib ko'ring."
            case .unknown_error_occured:
                return "Noma'lum xatolik yuz berdi."
            case .no_internet_connection:
                return "Qurilmada internet aloqa mavjud emas."
            case .validation_error:
                return "Tekshiruvdagi xatolik."
            case .invalid_phone_number:
                return "Mavjud bo'lmagan nomer"
            case .code_does_not_match:
                return "Maxfiy kodni birxilligini tekshiring"
            case .code_expired:
                return "Maxfiy kodni amal qilish muddati tugagan"
            case .rider_not_found:
                return "Yo'lovchi topilmadi"
            case .couldnt_send_sms:
                return "Xabar yuborib bo'lmadi"
            case .user_already_exist:
                return "Bu foydalanuvchi mavjud"
            case .user_not_found:
                return "Foydalanuvchi topilmadi"
            case .car_class_not_found:
                return "Mashina turini tanlang"
            case .thanks_for_rating:
                return "Baholaganingiz uchun raxmat"
            case .driver_not_found:
                return "Haydovchi topilmadi"
            case .no_enough_permission:
                return "Ruxsat yo'q"
            case .succesfully_updated:
                return "Muvaffaqiyatli yangilandi"
                
            case .entrance:
                return "Kirish"
            case .p_enter_entrance_number:
                return "Podyezd raqamini yozing"
            case .card_number:
                return "Karta raqami"
            case .card_number_placeholder:
                return "8600 000 0000 0000 0000"
            case .expire_date:
                return "Amal qilish muddati"
            case .expire_date_placeholder:
                return "ОО/YY"
            case .card_not_found:
                return "Karta topilmadi"
            case .card_not_found_in_rider :
                return "Bu foydalanuvchida hech qanday karta topilmadi"
            case .please_fill_the_fields:
                return "Iltimos barcha maydonlarni to'ldiring"
            case .card:
                return "Karta"
            case .enter_rider_phone_number:
                return "Yo'lovchi raqamini kirting"
            case .order_for_someone:
                return "Boshqa odam nomiga buyurtma"
            case .succesfully_deleted_card:
                return "Sizning kartangiz muvaffaqiyatli o'chirildi"
            case .do_u_want_to_delete_card:
                return "Kartani o'chirishni istaysizmi?"
            case .delete:
                return "O'chirish"
            case .greeting:
                return "Assalomu alaykum"
            case .dear_user:
                return "Qadrli foydalanuvchi"
            case .start_price:
                return "Minimal narx(1 km ni o'z ichiga olgan holda) - "
            case .per_km_value:
                return "Shahar ichida - "
            case .waiting_time:
                return "Bepul kutish vaqti - "
            case .per_minute_value:
                return "Pulli kutish vaqti - "
            case .minute:
                return "daqiqa"
            case .km:
                return "km"
            case .suburb:
                return "Shahar tashqarisida - "
            case .in_ride_waiting:
                return "Yo'lda kutish - "
            case .sender_and_reciever:
            return "Kimdan va kimga"
            case .pickup_location:
            return "Jo'natma qayerdan olib ketiladi?"
            case .package_sender:
            return "Jo'natmani kim topshiradi?"
            case .apartment_office:
            return "Xonadon, Ofis"
            case .floor:
            return "Qavat"
            case .door_phone:
            return "Domofon"
            case .comments:
            return "Izoh..."
            case .delivery_destination:
            return "Qayerga olib boriladi?"
            case .package_recipient:
            return "Jo'natmani kim qabul qilib oladi?"
            case .door_to_door:
            return "Eshikdan eshikkacha"
            case .order:
            return "Buyurtma berish"
            case .me:
            return "Men"
                
            case .please_choose_dest_address:
                return "Iltimos jo'natma uchun borish manzilini tanlang"
            case .please_choose_recipient_info:
                return "Iltimos jo'natma qabul qilivchi haqida ma'lumot kiriting"
            case .mins:
                return "daq."
            case .agree_lbl:
                return "Ro'yhatdan o'tish tugmasini bosish orqali siz quyidagilarga rozi bo'lasiz"
            case .agree_attributed:
                return "quyidagilarga"
            case .check_entered_info:
                return "Iltimos kiritilgan ma'lumotni qayta tekshirib ko'ring"
            case .please_resign:
                return "Iltimos ilova tizimidan chiqib qayta tizimga kiring"
            }
            
        }
    }
    
    
    //MARK: - Russian
    struct StringRu {
        static func getString(forType: StringType) -> String {
            switch forType {
            
            case .l_where_r_u_going:
                return "Куда едем?"
            case .l_top_label_in_main_view:
                return "Ваш адрес"
            case .l_top_subtitle_main_view:
                return "Уточняем..."
            case .b_next:
                return "Следующий"
            case .l_home:
                return "Главный"
            case .l_ride_history:
                return "История поездок"
            case .l_settings:
                return "Настройки"
            case .l_log_out:
                return "Выйти"
            case .b_refer_friend:
                return "Поделиться с другом"
            case .b_view_profile:
                return "Просмотреть профиль"
            case .l_refer_friend:
                return "Поделитeсь с другом"
            case .l_refer_friend_desc:
                return "Получите скидку, когда они катаются! Ваш друг тоже получит."
            case .l_share_refferal_code:
                return "Мой код"
            case .l_share_by_text:
                return "Поделиться через SMS"
            case .l_share_by_email:
                return "Поделиться по электронной почте"
            case .l_share_by_facebook:
                return "Поделиться через Facebook"
            case .l_share_by_other_way:
                return "Поделиться другими способоми"
            case .l_message_about_sharing_refferal_code:
                return "Это мой реферальный код в такси Дьод. Прокатитесь с этим кодом и получите невероятные скидки"
            case .l_profile:
                return "Профиль"
            case .l_firstname:
                return "Имя"
            case .l_lastname:
                return "Фамилия"
            case .l_phone_number:
                return "Номер телефона"
            case .b_update:
                return "Обновить"
            case .l_sum:
                return "сум"
            case .l_options:
                return "Пожелание"
            case .b_entrance:
                return "Подъезд"
            case .b_create_ride:
                return "Заказать"
            case .l_i_will_tell_the_driver:
                return "Скажу водителю"
            case .l_ride_options:
                return "Пожелания"
            case .l_air_conditioner:
                return "Кондиционер"
            case .l_comment:
                return "Комментарий"
            case .b_done:
                return "Готов"
            case .p_enter_comment:
                return "Введите комментарию"
            case .l_comment_1:
                return "Не звонить!"
                
            case .l_comment_2:
                return "Нужна помощь с багажом"
            case .l_comment_3:
                return "Звоните до приезда!"
            case .l_comment_4:
                return "Я жду на автобусной остановке"
            case .l_comment_5:
                return "В спешке! Прошу вас, как можно скорее!"
            case .l_comment_6:
                return "Очень уставший. Я хочу вздремнуть на заднем сиденье"
            case .l_searching:
                return "Поиск"
            case .l_searching_desc:
                return "Доступно несколько автомобилей, ищущих лучший вариант."
            case .l_cancel_order:
                return "Отменить заказ"
            case .l_one_more_car:
                return "Еще одна машина"
            case .a_preCancelled_alert_title:
                return "Извините, ваша поездка была отменена из-за того, что водитель не принял ее."
            case .a_b_retry:
                return "Повторить"
            case .a_b_cancel:
                return "Отмена"
            case .a_simple_alert_title:
                return "Вы хотите отменить?"
            case .a_simple_alert_desc:
                return "Вы уверены, что хотите отменить поездку?"
                
            case .user_setting:
                return "Пользовательские настройки"
            case .others:
                return "Другие"
            case .profile:
                return "Профиль"
            case .wallet:
                return "Кошелек"
            case .language:
                return "Язык приложения"
            case .request_support:
                return "Запросить поддержку"
            case .privacy_policy:
                return "Политика конфиденциальности"
            case .terms_conditions:
                return "Условия и положения"
            case .faq:
                return "Часто задаваемые вопросы"
            case .about_us:
                return "О нас"
            case .b_register:
                return "Зарегистрироваться"
            case .b_already_have_an_account:
                return "Уже есть аккаунт?"
            case .login:
                return "Вход"
            case .b_verify:
                return "Проверять"
            case .l_how_was_ride:
                return "Как прошла поездка?"
            case .l_comfortable_drive:
                return "Комфортная езда"
            case .l_great_navigation:
                return "Отличная навигация"
            case .l_clean:
                return "Чистий автомобиль"
            case .l_smooth_drive:
                return "Плавный привод"
            case .l_you_have_arrived_at_your_destination:
                return "Вы прибыли в пункт назначения"
            case .l_excellent:
                return "Cупер"
            case .l_very_good:
                return "Oтлично"
            case .l_good:
                return "Хорошо"
            case .l_not_bad:
                return "Не плохо"
            case .l_awful:
                return "Ужасно"
            case .log_out_alert_title:
                return "Выйти"
            case .log_out_alert_desc:
                return "Вы действительно хотите выйти?"
            case .a_b_ok:
                return "Потвердить"
            case .cash:
                return "Наличные"
            case .cost_of_your_ride:
                return "Стоимость вашей поездки "
            case .l_from:
                return "от"
            case .l_choose_payment_type:
                return "Способ оплаты"
            case .b_add_card:
                return "Добавить карту"
                
            case .request_view_title:
                return "Тема"
            case .request_view_detail:
                return "Детали"
            case .request_submit:
                return "Отправить"
                
                
            case .map:
                return "Карта"
            case .where_from:
                return "Откуда"
            case .where_to:
                return "Куда"
            case .order_details:
                return "Детали заказа"
            case .arriving_mins:
                return "Водитель приедет через"
            case .car_details:
                return "o машине"
            case .how_is_going_ride:
                return "Как вам поездка?"
            case .call:
                return "Вызов"
            case .chat:
                return "Чат"
            case .i_am_coming:
                return "Я выхожу"
            case .cancel_ride:
                return "Отменить заказ"
            case .share_route:
                return "Поделиться маршрутом"
            case .safety:
                return "Безопасность"
            case .driver_info:
                return "Водитель"
            case .route:
                return "Маршрут"
            case .time:
                return "Время"
            case .payment:
                return "Оплата"
            case .trusted_contacts:
                return "Надежные контакты"
            case .emergency_call:
                return "Экстренный вызов"
            case .ambulance_police:
                return "Скорая помощь"
                
            case .coming_soon:
                return "скоро будет"
                
            case .driver_is_here:
                return "Водитель вас ждёт"
            case .chat_with_driver:
                return "Чат с водителем"
            case .too_many_attempts:
                return "Слишком много попыток"
            case .unknown_error_occured:
                return "Произошла неизвестная ошибка"
            case .no_internet_connection:
                return "Подключение к Интернету отсутствует"
            case .validation_error:
                return "Ошибка проверки"
            case .invalid_phone_number:
                return "Неправильный номер телефона"
            case .code_does_not_match:
                return "Код не совпадает"
            case .code_expired:
                return "Срок действия кода истек"
            case .rider_not_found:
                return "Пассажир не найден"
            case .couldnt_send_sms:
                return "Невозможно отправлять смс"
            case .user_already_exist:
                return "Пользователь уже существует"
            case .user_not_found:
                return "Пользователь не найден"
            case .car_class_not_found:
                return "Класс автомобиля не найден"
            case .thanks_for_rating:
                return "Спасибо за оценку вашей поездки"
            case .driver_not_found:
                return "Водитель не найден"
            case .no_enough_permission:
                return "Недостаточно разрешения"
            case .succesfully_updated:
                return "Успешно обновлено"
            case .entrance:
                return "Подъезд"
            case .p_enter_entrance_number:
                return "Введите номер входа"
            case .card:
                return "Карта"
            case .card_number:
                return "Номер карты"
            case .card_number_placeholder:
                return "8600 000 0000 0000 0000"
            case .expire_date:
                return "Срок действие"
            case .expire_date_placeholder:
                return "MM/ГГ"
                
            case .card_not_found:
                return "Карта не найдена"
            case .card_not_found_in_rider :
                return "В этом пользователе не найдена"
            case .please_fill_the_fields:
                return "Пожалуйста заполните все поля"
            case .enter_rider_phone_number:
                return "Введите номер пассажира"
            case .order_for_someone:
                return "Заказ другому человеку"
            case .succesfully_deleted_card:
                return "Ваша карта успешно удалено"
            case .do_u_want_to_delete_card:
                return "Хотите удалить карту"
            case .delete:
                return "Удалить"
                
            case .greeting:
                return "Здраствуйте"
            case .dear_user:
                return "Дорогой пользователь"
            case .start_price:
                return "За первую 1 км"
            case .waiting_time:
                return "Ожидание"
            case .per_km_value:
                return "а затем за 1 км"
            case .per_minute_value:
                return "а затем за минуту"
            case .minute:
                return "минут"
            case .in_ride_waiting:
                return "Ожидание в поездке - "
            case .suburb:
                return "Загород - "
            case .km:
                return "км"
            case .sender_and_reciever:
                return "От кого и кому"
            case .pickup_location:
                return "Где забрать посылку?"
            case .package_sender:
                return "Кто одтаст посылку?"
            case .apartment_office:
                return "Квартира, офис"
            case .floor:
                return "Этаж"
            case .door_phone:
                return "Домофон"
            case .comments:
                return "Комментарий..."
            case .delivery_destination:
                return "Куда привезти?"
            case .package_recipient:
                return "Кто заберёт?"
            case .door_to_door:
                return "От двери до двери"
            case .order:
                return "Заказать"
            case .me:
            return "Я"
            case .please_choose_dest_address:
                return "Пожалуйста назначите адрес почты"
            case .please_choose_recipient_info:
                return "Назначите пожалуйста информацию о получателе"
            case .mins:
                return "мин."
            case .agree_lbl:
                return "Нажимая “Зарегистрироваться” я принимаю условия пользовательского соглашения"
            case .agree_attributed:
                return "условия пользовательского соглашения"
            case .check_entered_info:
                return "Пожалуйста проверьте информацию"
            case .please_resign:
            return "Пожалуйста, выйдите из приложения и войдите снова"

            }
            
            
        }
        
        
        
        
    }
    //MARK: - English
    struct StringEn {
        static func getString(forType: StringType) -> String {
            switch forType {
            
            case .l_where_r_u_going:
                return "Where are you going?"
            case .l_top_label_in_main_view:
                return "Your address"
            case .l_top_subtitle_main_view:
                return "Checking..."
            case .b_next:
                return "Next"
            case .l_home:
                return "Home"
            case .l_ride_history:
                return "Ride history"
            case .l_settings:
                return "Settings"
            case .l_log_out:
                return "Log out"
            case .b_refer_friend:
                return "Refer to a friend"
            case .b_view_profile:
                return "View profile"
            case .l_refer_friend:
                return "Refer to a friend"
            case .l_refer_friend_desc:
                return "Get great discounts when they ride! Your friend will get that discount too. Sweet"
            case .l_share_refferal_code:
                return "My refferal code"
            case .l_share_by_text:
                return "Share by text"
            case .l_share_by_email:
                return "Share by email"
            case .l_share_by_facebook:
                return "Share by facebook"
            case .l_share_by_other_way:
                return "Share by other way"
            case .l_message_about_sharing_refferal_code:
                return "This is my refferal code in Dyod. Get ride with this Dyod and get unbelievable discounts."
            case .l_profile:
                return "Profile"
            case .l_firstname:
                return "Firstname"
            case .l_lastname:
                return "Lastname"
            case .l_phone_number:
                return "Phone number"
            case .b_update:
                return "Update"
            case .l_sum:
                return "sum"
            case .l_options:
                return "Options"
            case .b_entrance:
                return "Entrance"
            case .b_create_ride:
                return "Find a route"
            case .l_i_will_tell_the_driver:
                return "Tell the driver address"
            case .l_ride_options:
                return "Ride options"
            case .l_air_conditioner:
                return "Air conditioner"
            case .l_comment:
                return "Comments"
            case .b_done:
                return "Done"
            case .p_enter_comment:
                return "Enter comment here"
            case .l_comment_1:
                return "I need help with my luggage"
            case .l_comment_2:
                return "Call me before arriving"
            case .l_comment_3:
                return "I am waiting at bus stop"
            case .l_comment_4:
                return "Call me, as soon as you will arrive"
            case .l_comment_5:
                return "Hurry up as soon as possible"
            case .l_comment_6:
                return "I am very tired. I want to take a nap in the back seat"
            case .l_searching:
                return "Searching"
            case .l_searching_desc:
                return "Several cars are available. Looking for the best match"
            case .l_cancel_order:
                return "Cancel order"
            case .l_one_more_car:
                return "Add one more car"
            case .a_preCancelled_alert_title:
                return "Sorry, your ride has been cancelled due to not accepted by any drivers."
            case .a_b_retry:
                return "Retry"
            case .a_b_cancel:
                return "Cancel"
            case .a_simple_alert_title:
                return "Do you want to cancel"
            case .a_simple_alert_desc:
                return "Are you sure do you want to cancel your ride?"
                
            case .user_setting:
                return "User settings"
            case .others:
                return "Others"
            case .profile:
                return "Profile"
            case .wallet:
                return "Wallet"
            case .language:
                return "Language"
            case .request_support:
                return "Request support"
            case .privacy_policy:
                return "Privacy policy"
            case .terms_conditions:
                return "Terms and conditions"
            case .faq:
                return "FAQ"
            case .about_us:
                return "About us"
            case .b_register:
                return "Register"
            case .b_already_have_an_account:
                return "Do you have an account?"
            case .login:
                return "Login"
            case .b_verify:
                return "Verify"
            case .l_how_was_ride:
                return "How was your ride?"
            case .l_comfortable_drive:
                return "Comfortable drive"
            case .l_great_navigation:
                return "Great navigation"
            case .l_clean:
                return "Clean"
            case .l_smooth_drive:
                return "Smooth drive"
            case .l_you_have_arrived_at_your_destination:
                return "You have arrived at your destination"
            case .l_excellent:
                return "Excellent"
            case .l_very_good:
                return "Very good"
            case .l_good:
                return "Good"
            case .l_not_bad:
                return "Not bad"
            case .l_awful:
                return "Awful"
            case .log_out_alert_title:
                return "Log out"
            case .log_out_alert_desc:
                return "Do you really want to log out?"
            case .a_b_ok:
                return "Ok"
            case .cash:
                return "Cash"
            case .cost_of_your_ride:
                return "Total cost of your ride "
            case .l_from:
                return "~"
            case .l_choose_payment_type:
                return "Choose payment type"
            case .b_add_card:
                return "Add card"
                
            case .request_view_title:
                return "Title"
            case .request_view_detail:
                return "Details"
            case .request_submit:
                return "Submit"
                
                
            case .map:
                return "Map"
            case .where_from:
                return "Where from"
            case .where_to:
                return "Where to"
            case .order_details:
                return "Order details"
            case .arriving_mins:
                return "Arriving in"
            case .car_details:
                return "Car details"
            case .how_is_going_ride:
                return "How is going your ride"
            case .call:
                return "Call"
            case .chat:
                return "Message"
            case .i_am_coming:
                return "I am coming"
            case .cancel_ride:
                return "Cancel ride"
            case .share_route:
                return "Share route"
            case .safety:
                return "Safety"
            case .driver_info:
                return "Driver info"
            case .route:
                return "Route"
            case .time:
                return "Time"
            case .payment:
                return "Payment"
            case .trusted_contacts:
                return "Trusted contacts"
            case .emergency_call:
                return "Emergency call"
            case .ambulance_police:
                return "Ambulance and Police"
                
            case .coming_soon:
                return "coming soon"
                
            case .driver_is_here:
                return "Driver is here"
            case .chat_with_driver:
                return "Chat with driver"
            case .too_many_attempts:
                return "Too many attempts"
            case .unknown_error_occured:
                return "Unknown error occured"
            case .no_internet_connection:
                return "No internet connection"
            case .validation_error:
                return "Validation error"
            case .invalid_phone_number:
                return "Invalid phone number"
            case .code_does_not_match:
                return "Code does not match"
            case .code_expired:
                return "Code expired"
            case .rider_not_found:
                return "Rider not found"
            case .couldnt_send_sms:
                return "Could not send sms"
            case .user_already_exist:
                return "User already exist"
            case .user_not_found:
                return "User not found"
            case .car_class_not_found:
                return "Car class not found"
            case .thanks_for_rating:
                return "Thank you for rating your ride"
            case .driver_not_found:
                return "Driver not found"
            case .no_enough_permission:
                return "No enough permission"
            case .succesfully_updated:
                return "Successfully updated"
            case .entrance:
                return "Entrance"
            case .p_enter_entrance_number:
                return "Enter entrance number"
            case .card_number:
                return "Card number"
            case .card_number_placeholder:
                return "8600 000 0000 0000 0000"
            case .expire_date:
                return "Expire date"
            case .expire_date_placeholder:
                return "MM/YY"
            case .card_not_found:
                return "Card not found"
            case .card_not_found_in_rider :
                return "Card not found in rider"
            case .please_fill_the_fields:
                return "Please fill all the fields"
            case .card:
                return "Card"
            case .enter_rider_phone_number:
                return "Еnter rider phone number"
            case .order_for_someone:
                return "Оrder for someone"
            case .succesfully_deleted_card:
                return "Card successfully deleted"
            case .do_u_want_to_delete_card:
                return "Do you want to delete your card"
            case .delete:
                return "Delete"
            case .greeting:
                return "Hello"
            case .dear_user:
                return "Dear User"
                
            case .start_price:
                return "Start price for 1 kilometr"
            case .waiting_time:
                return "Waiting time"
            case .per_km_value:
                return "then for 1 kilometr"
            case .per_minute_value:
                return "then for 1 minute"
            case .minute:
                return "minute"
            case .km:
                return "km"
            case .suburb:
                return "Thereafter in surburbs - "
            case .in_ride_waiting:
                return "Waiting during ride - "
            case .sender_and_reciever:
                return "Sender and recipient"
            case .pickup_location:
                return "Pickup location"
            case .package_sender:
                return "Package sender"
            case .apartment_office:
                return "Appartment, office"
            case .floor:
                return "Floor"
            case .door_phone:
                return "Door phone"
            case .comments:
                return "Comments..."
            case .delivery_destination:
                return "Delivery destination"
            case .package_recipient:
                return "Package recipient"
            case .door_to_door:
                return "Door to door"
            case .order:
                return "Order"
            case .me:
                return "Me"
            case .please_choose_dest_address:
                return "Please choose destination address for delivery"
            case .please_choose_recipient_info:
                return "Please choose recipient contact"
            case .mins:
            return "min." 
            case .agree_lbl:
                return "By clicking Register button I am agree to accept terms and conditions"
            case .agree_attributed:
                return "terms and conditions"
            case .check_entered_info:
                return "Please check infortmation you entered"
            case .please_resign:
                return "Please log out the app and log in again"
            }
            
        }
    }
    
}
