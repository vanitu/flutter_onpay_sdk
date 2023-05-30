
Пакет используется для интеграции Flutter приложения и платежного сервиса **onpay.ru**

Пакет предоставляет возможность пользователям приложения производить оплату внутри приложения с помощью банквоских карт и других методов платежа поддерживаемых [https://onpay.ru] без выхода из приложения.


**ВАЖНО** 
This package maybe used only with existed merchant account at www.onpay.ru
Данный пакет возможно использовать только при наличии аккаунта магазина в [https://onpay.ru]

## Возможности

 - Оплата за товары и услуги без выхода из приложения 
 - Поддержка Visa/Mastercard payment within your application
 - Поддерживаются все методы платежей доступные для магазина

## Начало

**Для приема карт Visa/Mastercard/МИР**

 - Зарегистрируйтесь на [https://onpay.ru]
 - Заполните заявку на прием платажей по картам Visa/Mastercard (платежный метод "CRD" / "UNR")
 - Запросите техподдержку OnPay активировать API платежной формы API[https://wiki.onpay.ru/doku.php?id=api-for-pay-form]

## Установка

Add flutter_map to your pubspec:

```yaml
dependencies:
  flutter_onpay_sdk: any # or the latest version on Pub
```

### Android

Убедитесь что разрешение `INTERNET` добавлено в AndroidManifest
`<project root>/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Использование

Пример использования SDK расположен в папке **/examples**

Пример использования SDK

**По умолчанию используется метод платежа "CRD"**

```dart
import 'package:flutter_onpay_sdk/flutter_onpay_sdk.dart';


// 1. Создаем объект платежа
    OnPayOrder order = OnPayOrder(
        reference: "SOMEUNIQ"; //Уникальный ключ для отслеживания
        payAmount: 100, // Цена в рублях
        payFor: 'Продукт 1', //Описание продукта в платеже
        payMode: 'fix', // Код магазина onpay
        recipient: 'cloud_sciencejet_net', // Код магазина onpay
        userEmail: 'some@mail.ru', // email пользователя
        note: "Короткая заметка о продукте", // ОПЦИОНАЛЬНО. Дополнительное описание покупки
        interfaceTicker:  "CRD", // Указываем метод платежа доступный для магазина
        
        )

// 2. Вызов платежной формы внутри виджета. Открывает новый экран с платежной формой. Результатом будет объект OnPayResult содержащий OnPayOrder и статус платежа
    OnPayResult result = await OnPaySdk.openPaymentForm(context, order); 

// 3) Обработка результата платежа
    switch (result.status) {
      case OnPayResultCode.success:
        // "ОПЛАЧЕНО";
        break;
      case OnPayResultCode.fail:
        // "Ошибка оплаты";
        break;
      case OnPayResultCode.notCompleted:
        // "Оплата не закончена"
        break;
    }
```