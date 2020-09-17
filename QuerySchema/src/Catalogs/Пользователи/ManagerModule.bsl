///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
	Если НЕ Параметры.Отбор.Свойство("Служебный") Тогда
		Параметры.Отбор.Вставить("Служебный", Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаВыбора" ИЛИ Параметры.Свойство("РежимВыбора") Тогда
		
		ВыбраннаяФормаПоУмолчанию = ВыбраннаяФорма;
		ПользователиПереопределяемый.ПриОпределенииФормыВыбораПользователей(ВыбраннаяФорма, Параметры);
	    Если ВыбраннаяФормаПоУмолчанию <> ВыбраннаяФорма Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
