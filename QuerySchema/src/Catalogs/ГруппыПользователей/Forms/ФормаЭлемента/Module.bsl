///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Объект.Ссылка = Справочники.ГруппыПользователей.ПустаяСсылка()
	   И Объект.Родитель = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		
		Объект.Родитель = Справочники.ГруппыПользователей.ПустаяСсылка();
	КонецЕсли;
	
	Если Объект.Ссылка = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ЗаполнитьСтатусПользователей();
	
	ОбновитьСписокНедействительныхПользователей(Истина);
	УстановитьДоступностьСвойств(ЭтотОбъект);
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ГруппаШапка.ВыравниваниеЭлементовИЗаголовков = ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьСтатусПользователей();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ГруппыПользователей", Новый Структура, Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РодительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ВыборРодителя");
	
	ОткрытьФорму("Справочник.ГруппыПользователей.ФормаВыбора", ПараметрыФормы, Элементы.Родитель);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Объект.Состав.Очистить();
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		Для каждого Значение Из ВыбранноеЗначение Цикл
			ОбработкаВыбораПользователя(Значение);
		КонецЦикла;
	Иначе
		ОбработкаВыбораПользователя(ВыбранноеЗначение);
	КонецЕсли;
	ЗаполнитьСтатусПользователей();
	Элементы.Состав.Обновить();
	УстановитьДоступностьСвойств(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	СообщениеПользователю = ПеремещениеПользователяВГруппу(ПараметрыПеретаскивания.Значение, Объект.Ссылка);
	Если СообщениеПользователю <> Неопределено Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Перемещение пользователей'"), , СообщениеПользователю, БиблиотекаКартинок.Информация32);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СоставПриИзменении(Элемент)
	УстановитьДоступностьСвойств(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьПользователей(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормы.Вставить("РасширенныйПодбор", Истина);
	ПараметрыФормы.Вставить("ПараметрыРасширеннойФормыПодбора", ПараметрыРасширеннойФормыПодбора());
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, Элементы.Состав);

КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователей(Команда)
	ОбновитьСписокНедействительныхПользователей(Ложь);
	УстановитьДоступностьСвойств(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию(Команда)
	СоставСортироватьСтроки("ПоВозрастанию");
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию(Команда)
	СоставСортироватьСтроки("ПоУбыванию");
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	СоставПереместитьСтроку("Вверх");
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	СоставПереместитьСтроку("Вниз");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьСвойств(Форма)
	
	Элементы = Форма.Элементы;
	
	СоставГруппы = Форма.Объект.Состав;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Недействителен", Ложь);
	ЕстьДействительныеПользователи = СоставГруппы.НайтиСтроки(ПараметрыОтбора).Количество() > 0;
	
	ПараметрыОтбора.Вставить("Недействителен", Истина);
	ЕстьНедействительныеПользователи = СоставГруппы.НайтиСтроки(ПараметрыОтбора).Количество() > 0;
	
	ДоступностьКомандПеремещения =
		ЕстьДействительныеПользователи
		Или (ЕстьНедействительныеПользователи
			И Элементы.ПоказыватьНедействительныхПользователей.Пометка);
	
	Элементы.СоставПереместитьВверх.Доступность         = ДоступностьКомандПеремещения;
	Элементы.СоставПереместитьВниз.Доступность          = ДоступностьКомандПеремещения;
	Элементы.СоставКонтекстноеМенюПереместитьВверх.Доступность = ДоступностьКомандПеремещения;
	Элементы.СоставКонтекстноеМенюПереместитьВниз.Доступность  = ДоступностьКомандПеремещения;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Пользователь.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Состав.Недействителен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораПользователя(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
		Объект.Состав.Добавить().Пользователь = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПеремещениеПользователяВГруппу(МассивПользователей, НоваяГруппаВладелец)
	
	МассивПеремещенныхПользователей = Новый Массив;
	МассивНеПеремещенныхПользователей = Новый Массив;
	Для Каждого ПользовательСсылка Из МассивПользователей Цикл
		
		ПараметрыОтбора = Новый Структура("Пользователь", ПользовательСсылка);
		Если ТипЗнч(ПользовательСсылка) = Тип("СправочникСсылка.Пользователи")
			И Объект.Состав.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
			Объект.Состав.Добавить().Пользователь = ПользовательСсылка;
			МассивПеремещенныхПользователей.Добавить(ПользовательСсылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПользователиСлужебный.ФормированиеСообщенияПользователю(
		МассивПеремещенныхПользователей, НоваяГруппаВладелец, Ложь, МассивНеПеремещенныхПользователей);
	
КонецФункции

&НаСервере
Функция ПараметрыРасширеннойФормыПодбора()
	
	ВыбранныеПользователи = Новый ТаблицаЗначений;
	ВыбранныеПользователи.Колонки.Добавить("Пользователь");
	ВыбранныеПользователи.Колонки.Добавить("НомерКартинки");
	
	УчастникиГруппы = Объект.Состав.Выгрузить(, "Пользователь");
	
	Для каждого Элемент Из УчастникиГруппы Цикл
		
		СтрокаВыбранныеПользователи = ВыбранныеПользователи.Добавить();
		СтрокаВыбранныеПользователи.Пользователь = Элемент.Пользователь;
		
	КонецЦикла;
	
	ЗаголовокФормыПодбора = НСтр("ru = 'Подбор участников группы пользователей'");
	ПараметрыРасширеннойФормыПодбора = 
		Новый Структура("ЗаголовокФормыПодбора, ВыбранныеПользователи, ПодборГруппНевозможен",
		                 ЗаголовокФормыПодбора, ВыбранныеПользователи, Истина);
	АдресХранилища = ПоместитьВоВременноеХранилище(ПараметрыРасширеннойФормыПодбора);
	Возврат АдресХранилища;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСтатусПользователей()
	
	Для Каждого СтрокаСоставаГруппы Из Объект.Состав Цикл
		СтрокаСоставаГруппы.Недействителен = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаСоставаГруппы.Пользователь, "Недействителен");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокНедействительныхПользователей(ПередОткрытиемФормы)
	
	Элементы.ПоказыватьНедействительныхПользователей.Пометка = ?(ПередОткрытиемФормы, Ложь,
		НЕ Элементы.ПоказыватьНедействительныхПользователей.Пометка);
	
	Отбор = Новый Структура;
	
	Если Не Элементы.ПоказыватьНедействительныхПользователей.Пометка Тогда
		Отбор.Вставить("Недействителен", Ложь);
		Элементы.Состав.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
	Иначе
		Элементы.Состав.ОтборСтрок = Новый ФиксированнаяСтруктура();
	КонецЕсли;
	
	Элементы.Состав.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура СоставСортироватьСтроки(ТипСортировки)
	
	Если Не Элементы.ПоказыватьНедействительныхПользователей.Пометка Тогда
		Элементы.Состав.ОтборСтрок = Новый ФиксированнаяСтруктура();
	КонецЕсли;
	
	Если ТипСортировки = "ПоВозрастанию" Тогда
		Объект.Состав.Сортировать("Пользователь Возр");
	Иначе
		Объект.Состав.Сортировать("Пользователь Убыв");
	КонецЕсли;
	
	Если Не Элементы.ПоказыватьНедействительныхПользователей.Пометка Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("Недействителен", Ложь);
		Элементы.Состав.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоставПереместитьСтроку(НаправлениеПеремещения)
	
	Строка = Объект.Состав.НайтиПоИдентификатору(Элементы.Состав.ТекущаяСтрока);
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИндексТекущейСтроки = Строка.НомерСтроки - 1;
	Сдвиг = 0;
	
	Пока Истина Цикл
		Сдвиг = Сдвиг + ?(НаправлениеПеремещения = "Вверх", -1, 1);
		
		Если ИндексТекущейСтроки + Сдвиг < 0
		Или ИндексТекущейСтроки + Сдвиг >= Объект.Состав.Количество() Тогда
			Возврат;
		КонецЕсли;
		
		Если Элементы.ПоказыватьНедействительныхПользователей.Пометка
		 Или Объект.Состав[ИндексТекущейСтроки + Сдвиг].Недействителен = Ложь Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Объект.Состав.Сдвинуть(ИндексТекущейСтроки, Сдвиг);
	Элементы.Состав.Обновить();
	
КонецПроцедуры

#КонецОбласти
