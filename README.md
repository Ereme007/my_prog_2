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


|Test\Ref|Q|QR|QRS|RS|R|RSR|
| ------------- | ------------- | -------- | ------------- | ------------- | -------- | -------- |
|Q|70|4|4|17|2|0|
|QR|0|18|2|0|0|0|
|QRS|0|10|18|93|18|0|
|RS|11|0|13|200|1|0|
|R|0|52|15|21|86|0|
|RSR|15|22|0|1|0|1|

Точность (главная диагональ) состовляет: 393 из 694 (56.6%)


