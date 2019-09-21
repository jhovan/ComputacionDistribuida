defmodule Broadcast do

    def inicia do
        estado_inicial = %{:flag => false, :soyLider => false}
        recibe_mensaje(estado_inicial)
    end

    def recibe_mensaje(estado) do
        receive do
        mensaje ->
            {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)
            recibe_mensaje(nuevo_estado)
        end 
    end


    def procesa_mensaje({:id, id}, estado) do
        estado = Map.put(estado, :id, id)
        {:ok, estado}
    end

    def procesa_mensaje({:soyLider}, estado) do
        estado = Map.put(estado, :soyLider, true)
        {:ok, estado}
    end

    def procesa_mensaje({:vecinos, vecinos}, estado) do
        estado = Map.put(estado, :vecinos, vecinos)
        {:ok, estado}
    end

    def procesa_mensaje({:inicia}, estado) do
        estado = broadcast(estado)
        {:ok, estado}
    end

    def procesa_mensaje({:mensaje, m}, estado) do
        estado = broadcast(estado, m)
        {:ok, estado}
    end

    def broadcast(estado, m \\ nil) do
        %{:id => id, :vecinos => vecinos, :flag => flag, :soyLider => soyLider} = estado
        IO.puts "ID: #{id} M: #{m} FLAG: #{flag}"
        if soyLider and not flag do
            IO.puts "Soy el proceso inicial #{id} y envío mi ID a todos mis vecinos"
            Enum.map(vecinos, fn vecino -> send vecino, {:mensaje, id} end)
            Map.put(estado, :flag, true)
        else
            if m != nil and not flag do
                IO.puts "Soy el proceso #{id} y envio el mensaje #{m} a todos mis vecinos"
                Enum.map(vecinos, fn vecino -> send vecino, {:mensaje, m} end)
                Map.put(estado, :flag, true)
            else 
                estado
            end 
        end
    end
end


a = spawn(Broadcast, :inicia, [])
b = spawn(Broadcast, :inicia, [])
c = spawn(Broadcast, :inicia, [])
d = spawn(Broadcast, :inicia, [])
e = spawn(Broadcast, :inicia, [])
f = spawn(Broadcast, :inicia, [])
g = spawn(Broadcast, :inicia, [])
h = spawn(Broadcast, :inicia, [])
i = spawn(Broadcast, :inicia, [])
j = spawn(Broadcast, :inicia, [])
k = spawn(Broadcast, :inicia, [])
l = spawn(Broadcast, :inicia, [])
m = spawn(Broadcast, :inicia, [])

send a, {:id, 1}
send b, {:id, 2}
send c, {:id, 3}
send d, {:id, 4}
send e, {:id, 5}
send f, {:id, 6}
send g, {:id, 7}
send h, {:id, 8}
send i, {:id, 9}
send j, {:id, 10}
send k, {:id, 11}
send l, {:id, 12}
send m, {:id, 13}

send k, {:soyLider}

send a, {:vecinos, [l,m,d]}
send b, {:vecinos, [k]}
send c, {:vecinos, [i]}
send d, {:vecinos, [a,e]}
send e, {:vecinos, [d,g,k]}
send f, {:vecinos, [h]}
send g, {:vecinos, [e]}
send h, {:vecinos, [f,j,k]}
send i, {:vecinos, [c,j]}
send j, {:vecinos, [i,h]}
send k, {:vecinos, [b,e,h]}
send l, {:vecinos, [a]}
send m, {:vecinos, [a]}

send a, {:inicia}
send b, {:inicia}
send c, {:inicia}
send d, {:inicia}
send e, {:inicia}
send f, {:inicia}
send g, {:inicia}
send h, {:inicia}
send i, {:inicia}
send j, {:inicia}
send k, {:inicia}
send l, {:inicia}
send m, {:inicia}
