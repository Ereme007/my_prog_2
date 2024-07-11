[API](https://docs.google.com/document/d/15S-l3xFYkZzDPjWqhdg8-dzoC4kjOaoLgrXlObL3mHI/edit)

[Здесь](https://docs.google.com/spreadsheets/d/1XD9cMNXDkx_SQkhQfctSiTL_ooMIVG1hnuiRw8Ysd_Q/edit?usp=sharing) лежит таблица с референтными именами комплексов для CTS, взятыми из Атласа, и результатами первого и последнего тестов.

[DTW CTS](https://docs.google.com/spreadsheets/d/16_rrhj5hArVJwm8eLntaSSrybjEHx4Ql2goQJncBXg0/edit?gid=305734201#gid=305734201)

Описание:

Три модуля в папке src (+1):
- Readers.jl
- DTWfunc.jl
- Plotting.jl
- Stats.jl

Readers.jl - модуль, считывающий входящий сигнал. Определены дополднительные функции для работы
DTWfunc.jl - модуль, выполняющий алгоритм DTW
Plotting.jl - модуль отрисовки и сохранения статистики 
Stats.jl - модуль статистика-проверка между полученным результатом и референтными значениями

Файлы в папке scripts:
- read_data.jl - файл, считывающий сигнал из базы данных
- process_data.jl - результат работы DTW
- star.jl - отрисовка и сбор статистики
- Testing_functions.jl - файл с тестированием новых функций
- Statistic_with_ref.jl - файл сбора статистики

Результаты, которые получились на данный момент:


|Test\Ref|Q|QR|QRS|RS|R|RSR|Точность для каждого класса
| ------------- | ------------- | -------- | ------------- | ------------- | -------- | -------- | -------- |
|Q|70|4|4|17|2|0|72.92%|
|QR|0|18|2|0|0|0|16.67%|
|QRS|0|10|18|93|18|0|36.73%|
|RS|11|0|13|200|1|0|60.24%|
|R|0|52|15|21|86|0|82.69%|
|RSR|15|22|0|1|0|1|-|
|-|96|105|52|332|108|1|-|

Точность (главная диагональ) состовляет: 393 из 694 (56.6%)

УЛУЧШЕНИЕ
Добавлен QR (1 шаблон: №1 ch4)
|Test\Ref|Q|QR|QRS|RS|R|RSR|
| ------------- | ------------- | -------- | ------------- | ------------- | -------- | -------- |
|Q|70|4|4|17|2|0|
|QR|0|32|3|1|1|0|
|QRS|0|3|17|92|17|0|
|RS|11|0|13|200|1|0|
|R|0|45|15|21|86|0|
|RSR|15|22|0|1|0|1|


Точность (главная диагональ) состовляет: 406 из 694 (58.5%)


Добавлен QR (2 шаблон: №1 ch4; №10 ch4)
|Test\Ref|Q|QR|QRS|RS|R|RSR|
| ------------- | ------------- | -------- | ------------- | ------------- | -------- | -------- |
|Q|70|4|4|17|2|0|
|QR|0|60|4|1|5|0|
|QRS|0|2|17|92|17|0|
|RS|11|0|13|200|1|0|
|R|0|18|14|21|82|0|
|RSR|15|22|0|1|0|1|

Точность (главная диагональ) состовляет: 430 из 694 (61.96%); определено QR 60 из 105 (-%)


Добавлен QR (2 шаблон: №1 ch4; №10 ch4; №46 ch4)
|Test\Ref|Q|QR|QRS|RS|R|RSR|
| ------------- | ------------- | -------- | ------------- | ------------- | -------- | -------- |
|Q|70|3|4|17|2|0|
|QR|10|78|4|1|5|0|
|QRS|0|2|17|92|17|0|
|RS|11|0|13|200|1|0|
|R|0|18|14|21|82|0|
|RSR|5|5|0|1|0|1|

Точность (главная диагональ) состовляет: 448 из 694 (64.55%); определено QR 78 из 105 (74.29%)

Добавлен QR (2 шаблон: №1 ch4; №10 ch4; №46 ch4; №35 ch3)
|Test\Ref|Q|QR|QRS|RS|R|RSR|
| ------------- | ------------- | -------- | ------------- | ------------- | -------- | -------- |
|Q|70|3|4|17|2|0|
|QR|10|89|11|3|19|0|
|QRS|0|2|17|92|17|0|
|RS|11|0|13|199|1|0|
|R|0|7|7|20|68|0|
|RSR|5|5|0|1|0|1|

Точность (главная диагональ) состовляет: 444 из 694 (63.98%) определено QR 89 из 105 (84.76%)
