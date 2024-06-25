#Diplome Eremenko Elizaveta
using Plots

x = Int64[]
N = 720
#База темплейтов y_templates
y_templates = Float64[]
for i in 1:360*2
    push!(x, i)
    push!(y_templates, sind(i))
end
plot(x, y_templates)

#============================================#

#Сигнал, которой дали на вход1
y_sig = Float64[]
for i in 1:N
    push!(y_sig, sind(i)+rand()*0.1)
end
plot!(x, y_sig)


#Сигнал, которой дали на вход2
y_sig2 = Float64[]
for i in 1:N
    push!(y_sig2, cosd(i)+rand()*0.1)
end
plot!(x, y_sig2)

#=============================================#
y_templates
#Алгоритм DTW
#A - матрица выравнивания

A = fill(0.0, (N+1, N+1))
for i in 1:N
    A[1, i+1] = y_templates[i]
    A[i+1, 1] = y_sig[i]
end

#Теперь заполняем матрицу (разность)
for i in 2:N+1
    for j in 2:N+1
        A[j, i] = abs(A[1, i]-A[j, 1])#Обычное расстояние
    #   A[j, i] = abs(A[1, i]-A[j, 1])^2#Евклидово расстояние
    end
end


#D - матрица трансформации
D = copy(A)
for i in 2:N+1
    for j in 2:N+1
        D[i, j] = D[i, j] + min(D[i-1, j], D[i-1, j-1], D[i, j-1])
    end
end







#tester
Mater_test = [[0,1,2,4,1]  [1,0,0,0,0]  [5,0,0,0,0] [4,0,0,0,0] [2,0,0,0,0]]
for i in 2:5
    for j in 2:5
        Mater_test[j, i] = abs(Mater_test[1, i]-Mater_test[j, 1])#Обычное расстояние
    end
end
Mater_test
D = copy(Mater_test)
D_new = D[1:end .!= 1, 1:end .!= 1]
#Уменьшаем матрицу - внешние границы убрать чтобы избедать ошибки!
#решим с краями
D_new[1, 1]
for i in 2:4
D_new[1, i] =  D_new[1, i-1] + D_new[1, i]
D_new[i, 1] =  D_new[i-1, 1] + D_new[i, 1]
end
D_new

for i in 2:4
    for j in 2:4
        #решаем всё остальное
        mmin = min(D_new[i-1, j], D_new[i-1, j-1], D_new[i, j-1])
        D_new[i, j] = D[i+1, j+1] + mmin
    end
end

hight, width = size(D_new)
D_new
#D_new[4, 4]
D_new[hight, width]



## Алгоритм из википедии с необходимыми обозначениями
#Первый этап
#Рассмотрим 2 временных ряда - Q длины n и C длины m:
#Q = q1, q2, q3, ..., qn; #вертикаль
#C = c1, c2, c3, ..., cm; #горизонталь

#Строим матрицу d порядка m x n (матрица расстояний), в котором эл-т dij есть расстояние d(qi, cj) между двумя точками qi и cj.
#d(qi, cj) = |qi, cj|

#Тестовый пример
C = [1, 5, 4, 2]
Q = [1, 2, 4, 1]


#C = -2, 10, -10, 15, -13, 20, -5, 14, 2
#Q = 3, -13, 14, -7, 9, -2

#Q = 1, 7, 4, 8, 2, 9, 6, 5, 2, 0
#C = 1, 2, 8, 5, 5, 1, 9, 4, 6, 5

#Q = 1, 7, 4, 8, 2, 9, 6, 5, 2, 0
#C = 1, 7, 4, 8, 2, 9, 8, 5, 2, 0

#Q = 6, 5, 4, 3, 2, 1
#C = 4, 3, 2, 1




#Второй этап
#Строим матрицу трансформаций D, каждый элемент которой вычисляется исходя из следующего соотношения:
#Di,j = di,j + min(Di-1,j , Di-1,j-1, , Di,j-1)
Q
C

function DTW(Q, C)
n = length(Q)
m = length(C)

d = fill(0.0, (n, m))
for i in 1:n
    for j in 1:m
        d[i, j] = abs(Q[i] - C[j])
    end
end
d
D = fill(0.0, (n, m))
D[1, 1] = d[1, 1]
for j in 2:m
    D[1, j] = d[1, j] + D[1, j-1]
   # @info "Q= $(Q[j]); C=$(C[1]); D[1, $j] = $(D[1, j])"
end
D
for i in 2:n
    D[i, 1] = d[i, 1] + D[i-1, 1]
 #   @info "D[$i, 1] = $(D[i, 1])"
end


D

for i in 2:n
    for j in 2:m
          #  @info "i = $i"
            D[i, j] = d[i, j] + min(D[i-1,j] , D[i-1,j-1] , D[i,j-1])
    end
end
D
return D
end
D = DTW(Q,C)



#Заключительный этап
#построить некоторый оптимальный путь трансформации (деформации) и DTW расстояние (стоимость пути)
#Путь трансформации W - набор смежных эл-тов матрицы, который устанавливает соотв-ие между Q и C.
#Предстаавляет собой путь, который минимизирует общее расстояние между Q и C.
#k-ый эл-т пути W определяется как
#w_k(i, j)_k; d(w_k) = d(qi, cj) = |qi-cj| или (qi - cj)^2
#Таким образом W = w_1, w_2, ... , w_k, ..., w_K; ,ax(m, n) <= K < m+n, K- длина пути

#делаем путь
function check(Number)
    if Number == 0
        return 1
    else
        return Number
    end
end

function New_position(hight, width, D)

    if D[hight-1|>check, width-1|>check] < D[hight, width-1|>check] && D[hight-1|>check, width-1|>check] < D[hight-1|>check, width]
        curr_hight = hight-1|>check
        curr_width = width-1|>check
    elseif D[hight, width-1|>check] < D[hight-1|>check, width]
        curr_hight = hight
        curr_width = width-1|>check
    else
        curr_hight = hight-1|>check
        curr_width = width
    end
        return curr_hight, curr_width
end

function path(D)
hight, width = size(D)
D[1, 1]
Mass = []
while ((hight, width) != (1, 1))
    push!(Mass, New_position(hight, width, D))
    hight, width = New_position(hight, width, D)
end
Mass
#K = length(Mass)+1

return Mass
end
Massix=path(D)
#Сложить все числа пути и разделить на K 0_0
function summ_K(Mass, m, n, D)
    summarize = D[n, m]
    i = 1
  #  @info "lastindex(Mass) = $(lastindex(Mass))"
    while (i <= lastindex(Mass))
     #   @info "i = $i, Mass[i] = $(Mass[i])"
        x, y = Mass[i]

        summarize = summarize + D[x, y]
        i = i+1
    end
    return summarize
end

#ch1 = summ_K(Mass, m, n, D)/K

#ch2 = summ_K(Mass, m, n, D)/K #чем меньше это число тем  ближе к этому темплейту =) 0-это исходный
function Find_koeff(Mass, Q, C, D)
    @info "Mass = $Mass"
    K = length(Mass)+1
    m = length(C)
    n = length(Q)
    return summ_K(Mass, m, n, D)/K 
end



##Итоговое тестирование
C = [1, 5, 4, 2]
Q = [1, 2, 4, 1]

C = y_templates
Q = y_sig

Q = [1, 7, 4, 8, 2, 9, 6, 5, 2, 0]
C = [1, 7, 4, 8, 2, 9, 8, 5, 2, 0]


Matrix_DTW = DTW(Q, C)
Mass_path = path(Matrix_DTW)
Find_koeff(Mass_path, Q, C, Matrix_DTW)

if length(Q) > length(C)
    length_signal = length(Q)
else
    length_signal = length(C)
end
i = 1
x = Int64[]
while i != length_signal+1
    push!(x, i)
    i = i+1
end

plot(x, [Q, C], label=["Q-signal" "C-templates"])

