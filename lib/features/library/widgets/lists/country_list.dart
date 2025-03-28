import 'package:flutter/material.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../data/models/country/country_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

final List<CountryModel> countries = [
  CountryModel('+61', 'AU', 'Австралия', 'Australia', AppVectors.aus),
  CountryModel('+43', 'AT', 'Австрия', 'Austria', AppVectors.aut),
  CountryModel('+994', 'AZ', 'Азербайджан', 'Azerbaijan', AppVectors.aze),
  CountryModel('+358', 'AX', 'Аландские острова', 'Åland', AppVectors.ala),
  CountryModel('+355', 'AL', 'Албания', 'Shqipëri', AppVectors.ala),
  CountryModel('+213', 'DZ', 'Алжир', 'Algeria', AppVectors.dza),
  CountryModel('+1', 'AS', 'Американское Самоа', 'American Samoa', AppVectors.asm),
  CountryModel('+1', 'AI', 'Ангилья', 'Angullia', AppVectors.aia),
  CountryModel('+376', 'AD', 'Андорра', 'Andorra', AppVectors.and),
  CountryModel('+1', 'AG', 'Антигуа и Барбуда', 'Antigua & Barbuda', AppVectors.atg),
  CountryModel('+244', 'AO', 'Ангола', 'Angola', AppVectors.ago),
  CountryModel('+54', 'AR', 'Аргентина', 'Argentina', AppVectors.arg),
  CountryModel('+374', 'AM', 'Армения', 'Հայաստան', AppVectors.arm),
  CountryModel('+297', 'AW', 'Аруба', 'Aruba', AppVectors.abw),
  CountryModel('+93', 'AF', 'Афганистан', 'افغانستان', AppVectors.afg),
  CountryModel('+973', 'BH', 'Бахрейн', 'البحرين', AppVectors.bhr),
  CountryModel('+880', 'BD', 'Бангладеш', 'বাংলাদেশ', AppVectors.bgd),
  CountryModel('+880', 'BB', 'Барбадос', 'Barbados', AppVectors.brb),
  CountryModel('+375', 'BY', 'Беларусь', '', AppVectors.blr),
  CountryModel('+32', 'BE', 'Бельгия', 'Belgiё', AppVectors.bel),
  CountryModel('+501', 'BZ', 'Белиз', 'Belize', AppVectors.blz),
  CountryModel('+229', 'BJ', 'Бенин', 'Bénin', AppVectors.ben),
  CountryModel('+441', 'BM', 'Бермудские острова', 'Bermuda', AppVectors.bmu),
  CountryModel('+975', 'BT', 'Бутан', 'འབྲུག་ཡུལ', AppVectors.btn),
  CountryModel('+591', 'BO', 'Боливия', 'Bolivia', AppVectors.bol),
  CountryModel('+535', 'BQ', 'Бонайре, Синт-Эстатиус и Саба', 'Bonaire, Sint Eustatius en Saba', AppVectors.bon),
  CountryModel('+387', 'BA', 'Босния и Герциговина', 'Bosna i Hercegovina', AppVectors.bih),
  CountryModel('+267', 'BW', 'Ботсвана', 'Botswana', AppVectors.bwa),
  CountryModel('+55', 'BR', 'Бразилия', 'Brasil', AppVectors.bra),
  CountryModel('+246', 'IO', 'Британская территория Индийского океана', 'British Indian Ocean Territory', AppVectors.iot),
  CountryModel('+673', 'BN', 'Бруней', 'بروني', AppVectors.brn),
  CountryModel('+359', 'BG', 'Болгария', 'България', AppVectors.bgr),
  CountryModel('+1242', 'BS', 'Багамы', 'Bahamas', AppVectors.bhs),
  CountryModel('+226', 'BF', 'Буркина-Фасо', 'Burkina Faso', AppVectors.bfa),
  CountryModel('+257', 'BI', 'Бурунди', 'Burundi', AppVectors.bdi),
  CountryModel('+47', 'BV', 'Буве остров', 'Bouvetøya', AppVectors.bvt),
  CountryModel('+678', 'VU', 'Вануату', 'Vanuatu', AppVectors.vut),
  CountryModel('+379', 'VA', 'Ватикан', 'Civitas Vaticana', AppVectors.vat),
  CountryModel('+44', 'GB', 'Великобритания', 'United Kingdom', AppVectors.gbr),
  CountryModel('+36', 'HU', 'Венгрия', 'Magyarország', AppVectors.hun),
  CountryModel('+58', 'VE', 'Венесуэла', 'Venezuela', AppVectors.ven),
  CountryModel('+850', 'VI', 'Виргинские Острова (США)','U.S Virgin Islands', AppVectors.vir),
  CountryModel('+092', 'VG', 'Виргинские Острова (Великобритания)', 'British Virgin Islands', AppVectors.vgb),
  CountryModel('+670', 'TL', 'Восточный Тимор','Timor Lorosa’e', AppVectors.tls),
  CountryModel('+84', 'VN', 'Вьетнам', 'Việt Nam', AppVectors.vnm),
  CountryModel('+241', 'GA', 'Габон', 'Gabon', AppVectors.gab),
  CountryModel('+220', 'GM', 'Гамбия', 'Gambia', AppVectors.gmb),
  CountryModel('+590', 'GP', 'Гваделупа', 'Guadeloupe', AppVectors.guf),
  CountryModel('+995', 'GE', 'Грузия', 'საქართველო', AppVectors.geo),
  CountryModel('+49', 'DE', 'Германия', 'Deutschland', AppVectors.deu),
  CountryModel('+44', 'GG', 'Гернси', 'Guernsey', AppVectors.ggy),
  CountryModel('+350', 'GI', 'Гибралтар', 'Gibraltar', AppVectors.gib),
  CountryModel('+30', 'GR', 'Греция', 'Ελλάδα', AppVectors.grc),
  CountryModel('+299', 'GL', 'Гренландия', 'Kalaallit Nunaat', AppVectors.grl),
  CountryModel('+502', 'GT','Гватемала', 'Guatemala', AppVectors.gtm),
  CountryModel('+224', 'GN', 'Гвинея', 'Guinée', AppVectors.gin),
  CountryModel('+245', 'GW', 'Гвинея-Бисау', 'Guiné-Bissau', AppVectors.gnb),
  CountryModel('+592', 'GY', 'Гайана', 'Guyana', AppVectors.guy),
  CountryModel('+509', 'HT', 'Гаити', 'Haïti', AppVectors.hti),
  CountryModel('+504', 'HN', 'Гондурас', 'Honduras', AppVectors.hnd),
  CountryModel('+852', 'HK', 'Гонконг', '香港', AppVectors.hkg),
  CountryModel('+473', 'GD', 'Гренада', 'Grenada', AppVectors.grd),
  CountryModel('+995', 'GU', 'Гуам', 'Guinée', AppVectors.gum),
  CountryModel('+45', 'DK', 'Дания', 'Danmark', AppVectors.dnk),
  CountryModel('+832', 'JE', 'Джерси', 'Jersey', AppVectors.jey),
  CountryModel('+253', 'DJ', 'Джибути', 'جيبوتي,', AppVectors.dji),
  CountryModel('+1767', 'DM', 'Доминика', 'Dominica', AppVectors.dma),
  CountryModel('+809', 'DO', 'Республика Доминикана', 'República Dominicana', AppVectors.dom),
  CountryModel('+20', 'EG', 'Египет', 'مصر', AppVectors.egy),
  CountryModel('+260', 'ZM', 'Замбия', 'Zambia', AppVectors.zmb),
  CountryModel('+263', 'ZW', 'Зимбабве', 'Zimbabwe', AppVectors.zwe),
  CountryModel('+972', 'IL', 'Израиль', '‏יִשְׂרָאֵל,', AppVectors.isr),
  CountryModel('+91', 'IN', 'Индия', 'भारतहिंदुस्तान', AppVectors.ind),
  CountryModel('+62', 'ID', 'Индонезия', 'Indonesia', AppVectors.idn),
  CountryModel('+962', 'JO', 'Иордания','الأردن', AppVectors.jor),
  CountryModel('+98', 'IR', 'Иран', 'ایران', AppVectors.irn),
  CountryModel('+964', 'IQ', 'Ирак', 'الْعِرَاق', AppVectors.irq),
  CountryModel('+353', 'IE', 'Ирландия','Éire', AppVectors.irl),
  CountryModel('+354', 'IS', 'Исландия','Iceland', AppVectors.isl),
  CountryModel('+34', 'ES', 'Испания', 'España', AppVectors.esp),
  CountryModel('+39', 'IT', 'Италия', 'Italia', AppVectors.ita),
  CountryModel('+967', 'YE', 'Йемен', 'ٱلْيَمَن', AppVectors.yem),
  CountryModel('+7', 'KZ', 'Казахстан', 'Қазақстан', AppVectors.kaz),
  CountryModel('+254', 'KE', 'Кения', 'Kenya', AppVectors.ken),
  CountryModel('+686', 'KI', 'Кирибати', 'Kiribati', AppVectors.kir),
  CountryModel('+855', 'KH', 'Камбоджа', 'កម្ពុជា', AppVectors.khm),
  CountryModel('+237', 'CM', 'Камерун', 'Cameroun', AppVectors.cmr),
  CountryModel('+1', 'CA', 'Канада', 'Canada', AppVectors.can),
  CountryModel('+238', 'CV', 'Кабо-Верде', 'Cabo Verde', AppVectors.cpv),
  CountryModel('+1345', 'KY', 'Каймановы Острова', 'Cayman Islands', AppVectors.cym),
  CountryModel('+34', 'CT', 'Каталония', 'Catalunya', AppVectors.cat),
  CountryModel('+974', 'QA', 'Катар', 'قطر', AppVectors.qat),
  CountryModel('+86', 'CN', 'Китай', '中国', AppVectors.chn),
  CountryModel('+506', 'CR', 'Коста-Рика', 'Costa Rica', AppVectors.cri),
  CountryModel('+383', 'XK', 'Косово', 'Kosovё', AppVectors.kos),
  CountryModel('+53', 'CU', 'Куба', 'Cuba', AppVectors.cub),
  CountryModel('+599', 'CW', 'Кюрасао', 'Land Curaçao', AppVectors.cuw),
  CountryModel('+357', 'CY', 'Кипр', 'Κύπρος', AppVectors.cyp),
  CountryModel('+61', 'CC', 'Кокосовые острова', 'Kapelauan Cocos (Keepling)', AppVectors.cck),
  CountryModel('+57', 'CO', 'Колумбия', 'Colombia', AppVectors.col),
  CountryModel('+242', 'CG', 'Конго-Браззавиль', 'Congo-Brazzaville', AppVectors.cog),
  CountryModel('+269', 'KM', 'Коморы', 'Komori', AppVectors.com),
  CountryModel('+225', 'CI', 'Кот-д`Ивуар', 'Côte d’Ivoire', AppVectors.civ),
  CountryModel('+965', 'KW', 'Кувейт', 'الكويت', AppVectors.kwt),
  CountryModel('+996', 'KG', 'Киргизия', 'Кыргызстан', AppVectors.kgz),
  CountryModel('+856', 'LA', 'Лаос', 'ລາວ', AppVectors.lao),
  CountryModel('+371', 'LV', 'Латвия', 'Latvija', AppVectors.lva),
  CountryModel('+961', 'LB', 'Ливан', 'لُبْنَان', AppVectors.lbn),
  CountryModel('+266', 'LS', 'Лесото', 'Lesotho', AppVectors.lso),
  CountryModel('+231', 'LR', 'Либерия', 'Liberia', AppVectors.lbr),
  CountryModel('+218', 'LY', 'Ливия', 'ليبيا', AppVectors.lby),
  CountryModel('+423', 'LI', 'Лихтенштейн', 'Liechtenstein', AppVectors.lie),
  CountryModel('+370', 'LT', 'Литва', 'Lietuva', AppVectors.ltu),
  CountryModel('+352', 'LU', 'Люксембург', 'Lëtzebuerg', AppVectors.lux),
  CountryModel('+853', 'MO', 'Макао', '澳門', AppVectors.mac),
  CountryModel('+261', 'MG', 'Мадагаскар', 'Madagasikara', AppVectors.mdg),
  CountryModel('+265', 'MW', 'Малави', 'Malawi', AppVectors.mwi),
  CountryModel('+212', 'MA', 'Марокко', 'المغرب', AppVectors.mar),
  CountryModel('+60', 'MY', 'Малайзия', 'Malaysia', AppVectors.mys),
  CountryModel('+960', 'MV', 'Мальдивы', 'ހިވެދި ގުޖޭއްރާ', AppVectors.mdv),
  CountryModel('+223', 'ML', 'Мали','Mali', AppVectors.mli),
  CountryModel('+356', 'MT', 'Мальта','Malta', AppVectors.mlt),
  CountryModel('+692', 'MH', 'Маршалловы острова', 'Marshall Islands', AppVectors.mhl),
  CountryModel('+222', 'MR', 'Мавритания', 'موريتانيا', AppVectors.mrt),
  CountryModel('+230', 'MU', 'Маврикий', 'Mauritius', AppVectors.mus),
  CountryModel('+262', 'YT', 'Майотта', 'Mayotte', AppVectors.wlf),
  CountryModel('+52', 'MX', 'Мексика', 'México', AppVectors.mex),
  CountryModel('+691', 'FM', 'Микронезия', 'Micronesia', AppVectors.fsm),
  CountryModel('+373', 'MD', 'Молдавия', 'Moldova', AppVectors.mda),
  CountryModel('+377', 'MC', 'Монако', 'Monaco', AppVectors.mco),
  CountryModel('+976', 'MN', 'Монголия', 'Montserrat', AppVectors.mng),
  CountryModel('+1664', 'MS', 'Монтсеррат', 'Монгол Улс', AppVectors.msr),
  CountryModel('+95', 'MM', 'Мьянма (Бирма)','မြန်မာ', AppVectors.mmr),
  CountryModel('+258', 'MZ', 'Мозамбик', 'Moçambique', AppVectors.moz),
  CountryModel('+264', 'NA', 'Намибия', 'Namibia', AppVectors.nam),
  CountryModel('+674', 'NR', 'Науру', 'Naoero', AppVectors.nru),
  CountryModel('+977', 'NP', 'Непал', 'नेपाल', AppVectors.npl),
  CountryModel('+31', 'NL', 'Нидерланды', 'Nederland', AppVectors.nld),
  CountryModel('+687', 'NC', 'Новая Каледония', 'Nouvelle-Calédonie', AppVectors.ncl),
  CountryModel('+64', 'NZ', 'Новая Зеландия', 'New Zealand', AppVectors.nzl),
  CountryModel('+505', 'NI', 'Никарагуа', 'Nicaragua', AppVectors.nzl),
  CountryModel('+227', 'NE', 'Нигер', 'Niger', AppVectors.ner),
  CountryModel('+234', 'NG', 'Нигерия', 'Nigeria', AppVectors.nga),
  CountryModel('+683', 'NU', 'Ниуэ', 'Niue', AppVectors.niu),
  CountryModel('+47', 'NO', 'Норвегия', 'Norge', AppVectors.nor),
  CountryModel('+971', 'AE', 'Объединенные Арабские Эмираты', 'الإمارات,', AppVectors.are),
  CountryModel('+968', 'OM', 'Оман', 'عُمان', AppVectors.omn),
  CountryModel('+247', 'AC', 'Остров Вознесения', 'Ascension Island', AppVectors.asi),
  CountryModel('+44', 'IM', 'Остров Мэн', 'Isle of Man', AppVectors.imn),
  CountryModel('+682', 'CK', 'Острова Кука', 'Cook Islands', AppVectors.cok),
  CountryModel('+870', 'PN', 'Острова Питкэрн', 'Pitcairn Islands', AppVectors.pcn),
  CountryModel('+61', 'CX', 'Остров Рождества', 'Christmas Island', AppVectors.cxr),
  CountryModel('+290', 'SH', 'Остров Святой Елены', 'St. Elena Island', AppVectors.shn),
  CountryModel('+599', 'KY', 'Острова Кайман', 'Cayman Islands', AppVectors.cym),
  CountryModel('+92', 'PK', 'Пакистан', 'پاکستان', AppVectors.pak),
  CountryModel('+970', 'PS', 'Палестина', 'دولة فلسطي', AppVectors.pse),
  CountryModel('+680', 	'PW', 'Палау', 'Palau', AppVectors.plw),
  CountryModel('+507', 'PA', 'Панама', 'Panamá', AppVectors.pan),
  CountryModel('+675', 'PG', 'Папуа - Новая Гвинея', 'Papua New Guinea', AppVectors.png),
  CountryModel('+595', 'PY', 'Парагвай', 'Paraguay', AppVectors.pry),
  CountryModel('+51', 'PE', 'Перу', 'Perú', AppVectors.per),
  CountryModel('+48', 'PL', 'Польша', 'Polska', AppVectors.pol),
  CountryModel('+351', 'PT', 'Португалия', 'Portugal', AppVectors.prt),
  CountryModel('+620', 'PR', 'Пуэрто-Рико', 'Puerto Rico', AppVectors.pri),
  CountryModel('+262', 'RE', 'Реюньон', 'Réunion', AppVectors.reu),
  CountryModel('+7', 'RU', 'Россия', 'Russia', AppVectors.rus),
  CountryModel('+250', 'RW', 'Руанда', 'Rwandan', AppVectors.rwa),
  CountryModel('+40', 'RO', 'Румыния', 'România', AppVectors.rou),
  CountryModel('+503', 'SV', 'Сальвадор', 'El Salvador', AppVectors.slv),
  CountryModel('+685', 'WS', 'Самоа', 'Samoa', AppVectors.wsm),
  CountryModel('+378', 'SM', 'Сан-Марино', 'San Marino', AppVectors.smr),
  CountryModel('+239', 'ST', 'Сан-Томе и Принсипи', 'São Tomé and Príncipe', AppVectors.stp),
  CountryModel('+966', 'SA', 'Саудовская Аравия', 'ٱلسُّعُوْدِيَّة العربيّة', AppVectors.sau),
  CountryModel('+389', 'MK', 'Северная Македония', 'Северна Македонија', AppVectors.mkd),
  CountryModel('+1670', 'MP', 'Северные Марианские Острова', 'Northern Mariana Islands', AppVectors.mnp),
  CountryModel('+590', 'BL', 'Сен-Бартелеми', 'Saint-Barthélemy', AppVectors.wlf),
  CountryModel('+850', 'KP', 'Северная Корея', '北朝鮮', AppVectors.prk),
  CountryModel('+221', 'SN', 'Сенегал', 'Sénégal', AppVectors.sen),
  CountryModel('+221', 'VC', 'Сент-Винсент и Гренадины', 'St. Vincent & Grenadines', AppVectors.vct),
  CountryModel('+659', 'KN', 'Сент-Китс и Невис', 'St. Kitts &amp; Nevis', AppVectors.kna),
  CountryModel('+221', 'LC', 'Сент-Люсия', 'Saint Lucia', AppVectors.ica),
  CountryModel('+381', 'RS', 'Сербия', 'Србија', AppVectors.srb),
  CountryModel('+248', 'SC', 'Сейшельские острова', 'Sesel', AppVectors.syc),
  CountryModel('+232', 'SL', 'Сьерра-Леоне', 'Sierra Leone', AppVectors.sle),
  CountryModel('+65', 'SG', 'Сингапур', 'Singapura', AppVectors.sgp),
  CountryModel('+534', 'SX', 'Синт-Мартен', 'Sint Maarten', AppVectors.wlf),
  CountryModel('+421', 'SK', 'Словакия', 'Slovensko', AppVectors.svk),
  CountryModel('+386', 'SI', 'Словения', 'Slovenija', AppVectors.svn),
  CountryModel('+1', 'US', 'Соединенные Штаты Америки', 'United States of America', AppVectors.usa),
  CountryModel('+677', 'SB', 'Соломоновы острова', 'Solomon Islands', AppVectors.slb),
  CountryModel('+252', 'SO', 'Сомали', 'Soomaaliya', AppVectors.som),
  CountryModel('+508', 'PM', 'Сен-Пьер и Микелон', 'Saint-Pierre et Miquelon', AppVectors.spm),
  CountryModel('+249', 'SD', 'Судан', 'السودان', AppVectors.sdn),
  CountryModel('+597', 'SR', 'Суринам', 'Suriname', AppVectors.sur),
  CountryModel('+963', 'SY', 'Сирия', 'سُورِيَة', AppVectors.syr),
  CountryModel('+886', 'TW', 'Тайвань', '台灣', AppVectors.twn),
  CountryModel('+992', 'TJ', 'Таджикистан', 'Тоҷикистон', AppVectors.tjk),
  CountryModel('+255', 'TZ', 'Танзания', 'Tanzania', AppVectors.tza),
  CountryModel('+66', 'TH', 'Таиланд', 'ประเทศไทย', AppVectors.tha),
  CountryModel('+228', 'TG', 'Того', 'Togo,', AppVectors.tgo),
  CountryModel('+690', 'TK', 'Токелау', 'Tokelau,', AppVectors.tkl),
  CountryModel('+676', 'TO', 'Тонга', 'Tonga', AppVectors.ton),
  CountryModel('+1868', 'TT', 'Тринидад и Тобаго', 'Trinidad & Tobago', AppVectors.tto),
  CountryModel('+216', 'TN', 'Тунис', 'تونس', AppVectors.tun),
  CountryModel('+90', 'TR', 'Турция', 'Türkiye', AppVectors.tur),
  CountryModel('+993', 'TM', 'Туркменистан', 'Türkmenistan', AppVectors.tkm),
  CountryModel('+688', 'TV', 'Тувалу', 'Tuvalu', AppVectors.tuv),
  CountryModel('+256', 'UG', 'Уганда', 'Uganda', AppVectors.uga),
  CountryModel('+380', 'UA', 'Украина', 'Україна', AppVectors.ukr),
  CountryModel('+598', 'UY', 'Уругвай', 'Uruguay', AppVectors.ury),
  CountryModel('+998', 'UZ', 'Узбекистан', 'Oʻzbekiston', AppVectors.uzb),
  CountryModel('+681', 'WF', 'Уоллис и Футуна', 'Wallis-et-Futuna', AppVectors.wlf),
  CountryModel('+298', 'FO', 'Фарерские острова', '', AppVectors.fro),
  CountryModel('+679', 'FJ', 'Фиджи', 'Fiji', AppVectors.fji),
  CountryModel('+63', 'PH', 'Филиппины', 'Pilipinas', AppVectors.phl),
  CountryModel('+358', 'FI', 'Финляндия', 'Suomi', AppVectors.fin),
  CountryModel('+500', 'FK', 'Фолклендские острова', 'Falkland Islands', AppVectors.flk),
  CountryModel('+33', 'FR', 'Франция', 'France', AppVectors.fra),
  CountryModel('+689', 'PF', 'Французская Полинезия', 'Polynésie française', AppVectors.pyf),
  CountryModel('+594', 'GF', 'Французская Гвиана', 'Guyane Française', AppVectors.giu),
  CountryModel('+385', 'HR', 'Хорватия', 'Hrvatska', AppVectors.hrv),
  CountryModel('+236', 'CF', 'Центрально-Африканская Республика', 'République Centrafricaine', AppVectors.caf),
  CountryModel('+235', 'TD', 'Чад', 'Tchad', AppVectors.tcd),
  CountryModel('+382', 'ME', 'Черногория', 'Црна Гора / Crna Gora', AppVectors.mne),
  CountryModel('+420', 'CZ', 'Чехия', 'Česko', AppVectors.cze),
  CountryModel('+56', 'CL', 'Чили', 'Chile', AppVectors.chl),
  CountryModel('+41', 'CH', 'Швейцария', 'Schweiz', AppVectors.che),
  CountryModel('+46', 'SE', 'Швеция', 'Sverige', AppVectors.swe),
  CountryModel('+94', 'LK', 'Шри-Ланка', 'ශ්‍රී ලංකාව', AppVectors.lka),
  CountryModel('+47', 'SJ', 'Шпицберген', 'Svalbard', AppVectors.nor),
  CountryModel('+240', 'GQ', 'Экваториальная Гвинея', 'Guinea Ecuatorial', AppVectors.gnq),
  CountryModel('+593', 'EC', 'Эквадор', 'Ecuador', AppVectors.ecu),
  CountryModel('+291', 'ER', 'Эритрея', 'إرتريا', AppVectors.eri),
  CountryModel('+268', 'SZ', 'Эсватини', 'Eswatini', AppVectors.swz),
  CountryModel('+372', 'EE', 'Эстония', 'Eesti', AppVectors.est),
  CountryModel('+251', 'ET', 'Эфиопия', 'ኢትዮጵያ', AppVectors.eth),
  CountryModel('+27', 'ZA', 'Южная Африка', 'South Africa', AppVectors.zaf),
  CountryModel('+82', 'KR', 'Южная Корея', '南韓', AppVectors.kor),
  CountryModel('+211', 'SS', 'Южный Судан', 'South Sudan', AppVectors.ssd),
  CountryModel('+876', 'JM', 'Ямайка', 'Jamaica', AppVectors.jam),
  CountryModel('+81', 'JP', 'Япония', '日本', AppVectors.jpn),
];

Widget buildCountryList(BuildContext context) {
  final localizations = AppLocalizations.of(context);

  return ListView.builder(
    itemCount: countries.length,
    itemBuilder: (context, index) {
      final country = countries[index];
      final countryName = localizations.translate('countries.${country.name}');

      return ListTile(
        leading: SvgPicture.asset(country.flag),
        title: Text(countryName),
        subtitle: Text(country.nativeName),
      );
    },
  );
}

String? getCountryNameByCode(String code) {
  final country = countries.firstWhere(
        (country) => country.code.replaceAll('+', '') == code.replaceAll('+', ''),
    orElse: () => CountryModel('', '', '', '', ''),
  );
  return country.name.isNotEmpty ? country.name : null;
}
