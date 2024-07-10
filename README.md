[API](https://docs.google.com/document/d/15S-l3xFYkZzDPjWqhdg8-dzoC4kjOaoLgrXlObL3mHI/edit)

[Здесь](https://docs.google.com/spreadsheets/d/1XD9cMNXDkx_SQkhQfctSiTL_ooMIVG1hnuiRw8Ysd_Q/edit?usp=sharing) лежит таблица с референтными именами комплексов для CTS, взятыми из Атласа, и результатами первого и последнего тестов.

[DTW CTS](https://docs.google.com/spreadsheets/d/16_rrhj5hArVJwm8eLntaSSrybjEHx4Ql2goQJncBXg0/edit?gid=305734201#gid=305734201)

Описание:

Три модуля в папке src:
- Readers.jl
- DTWfunc.jl
- Plotting.jl

Readers.jl - модуль, считывающий входящий сигнал. Определены дополднительные функции для работы
DTWfunc.jl - модуль, выполняющий алгоритм DTW
Plotting.jl - модуль отрисовки и сохранения статистики 

Файлы в папке scripts:
- read_data.jl - файл, считывающий сигнал из базы данных
- process_data.jl - результат работы DTW
- star.jl - отрисовка и сбор статистики
- Testing_functions.jl - файл с тестированием новых функций
