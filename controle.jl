using DelimitedFiles, Dates
using Plots.PlotMeasures 
import Plots

# Plots.plotly()

data = readdlm("controle_mamadas.csv", ',')
df = DateFormat("d/m/y")

data2 = readdlm("controle_fraldas.csv", ',')
df2 = DateFormat("d.m.yy")

w = 5

yt = Time.(["0:00:00", "3:00:00", "6:00:00", "9:00:00", "12:00:00", "15:00:00", "18:00:00", "21:00:00", "23:59:00"])

if data[2,4] == "E"
    cl = "red"
else
    cl = "blue"
end
figura = Plots.plot(Date.([data[2,1], data[2,1]], df), Time.([data[2,2], data[2,3]]), color = cl, legend = false, linewidth = w, size=(1000,1228), left_margin=10mm, yticks = yt)
for i in 3:length(data[:,1])
    if data[i,4] == "E"
        cl = "red"
    else
        cl = "blue"
    end
    Plots.plot!(Date.([data[i,1], data[i,1]], df), Time.([data[i,2], data[i,3]]), color = cl, linewidth = w, legend = false)
end

Plots.scatter!(Date.(data2[2:end,1], df2) .+ Dates.Year(2000) , Time.(data2[2:end,2]), legend = false, markerstrokewidth = 0.5, markersize = 4, markercolor="yellow", label = "troca de fraldas")

Plots.savefig(figura,"controle_fig.pdf")

dias = unique(data[2:end,1])
tempo = Array{Minute}(undef,length(dias))
for d in 1:length(dias)
    id = findall(i -> i == dias[d], data[:,1])
    tempo[d] = sum(Minute.(Time.(data[id,5])))
end

figura2 = Plots.bar(Date.(dias, df), tempo, size = (800,400), legend = false, title = "Tempo total de mamadas")
Plots.savefig(figura2, "mamadas_tempo.pdf")

dias = unique(data2[2:end,1])
fraldas = Array{Int}(undef,length(dias))
for d in 1:length(dias)
    fraldas[d] = count(i -> i == dias[d], data2[:,1])
end

figura3 = Plots.bar(Date.(dias, df2) .+ Dates.Year(2000), fraldas, size = (800,400), legend = false, title = "Trocas de fralda")
Plots.savefig(figura3, "troca_fraldas.pdf")