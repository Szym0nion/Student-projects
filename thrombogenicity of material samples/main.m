% Wczytanie plików JPG
obraz = imread('Horizontal 06 5 min.jpg');
% Wyświetlanie obrazu
imshow(obraz);

%% Pion (Vertical)
oryginalna_wysokosc = size(obraz, 1);
oryginalna_szerokosc = size(obraz, 2);
rozmiar_podobrazu = [oryginalna_wysokosc/10, oryginalna_szerokosc];

%% Poziom (Horizontal)
oryginalna_wysokosc = size(obraz, 1);
oryginalna_szerokosc = size(obraz, 2);
rozmiar_podobrazu = [oryginalna_wysokosc, oryginalna_szerokosc/10];

%% 
podobrazy = cell(10, 10);  % Inicjalizacja komórki na podobrazy

for i = 1:10
    for j = 1:10
        % Oblicz współrzędne początkowe i końcowe dla podobrazu
        x_start = (i - 1) * rozmiar_podobrazu(1) + 1;
        x_end = i * rozmiar_podobrazu(1);
        y_start = (j - 1) * rozmiar_podobrazu(2) + 1;
        y_end = j * rozmiar_podobrazu(2);

        % Wytnij podobraz z oryginalnego obrazu
        podobrazy{i, j} = obraz(x_start:x_end, y_start:y_end);
    end
end

%%
for i = 1:10
    for j = 1:10
        subplot(10, 10, (i - 1) * 10 + j);  % Ustawienie odpowiedniego subplotu
        imshow(podobrazy{i, j});  % Wyświetlenie podobrazu
    end
end


%%
liczba_kropek = zlicz_czarne_kropki(obraz);
fprintf('Liczba czarnych kropek: %d\n', liczba_kropek);

%%
liczby_kropek_na_podobrazach = zeros(1, 10);

for i = 1:10
        % Wywołaj funkcję do zliczania kropel na podobrazie
        liczby_kropek_na_podobrazach(1, i) = zlicz_czarne_kropki_na_podobrazie(podobrazy{1, i});
end


%%
liczba_przedzialow = 1:1:10;  % Liczba przedziałów histogramu
bar(liczby_kropek_na_podobrazach);

title("Ilość komórek")
xlabel('Numer podobrazu')
ylabel('Ilość komórek')

%%
obraz = imread('Horizontal 06 5 min.jpg');
obraz_szaro = rgb2gray(obraz); % Konwersja na obraz w odcieniach szarości, jeśli obraz jest kolorowy


prog_binaryzacji = 50; % Możesz dostosować próg do Twojego obrazu
obraz_binarny = obraz_szaro < prog_binaryzacji;
etykiety = bwlabel(obraz_binarny);
regiony = regionprops(etykiety, 'Centroid', 'Area');
srodek_x = size(obraz, 2) / 2; % Środek w osi X
srodek_y = size(obraz, 1) / 2; % Środek w osi Y

numery_kropek = 1:numel(regiony);
odleglosci_od_srodka = arrayfun(@(x) norm(x.Centroid - [srodek_x, srodek_y]), regiony);
figure;
scatter(numery_kropek, odleglosci_od_srodka);
xlabel('Numer kropki');
ylabel('Odległość od środka');
title('Wykres odległości czarnych kropek od środka');

%%
obraz = imread('Horizontal 06 5 min.jpg');
obraz_szary = rgb2gray(obraz); % Przekształć na obraz w skali szarości

% Wybierz obszar zainteresowania (ROI)
x_start = 100; % Początkowa pozycja X obszaru zainteresowania
y_start = 150; % Początkowa pozycja Y obszaru zainteresowania
width = 200;   % Szerokość obszaru zainteresowania
height = 150;  % Wysokość obszaru zainteresowania

% Obetnij obszar zainteresowania z obrazu
roi = imcrop(obraz_szary, [x_start, y_start, width, height]);

% Wykryj krawędzie w obszarze zainteresowania
krawedzie = edge(roi, 'Canny');

% Znajdź punkty charakterystyczne (mogą to być np. ekstrema lokalne)
punkty = detectHarrisFeatures(krawedzie);

% Pobierz współrzędne punktów charakterystycznych
punkty_x = punkty.Location(:, 1);
punkty_y = punkty.Location(:, 2);

% Oblicz odległość od środka obszaru zainteresowania do każdego punktu charakterystycznego
srodek_obszaru = [width / 2, height / 2]; % Środek obszaru zainteresowania
odleglosci = sqrt((punkty_x - srodek_obszaru(1)).^2 + (punkty_y - srodek_obszaru(2)).^2);

% Oblicz naprężenie na podstawie odległości i masy czarnej kropki
masa_kropki_pg = 30; % Masa czarnej kropki w pikogramach
masa_kropki_kg = masa_kropki_pg * 1e-12; % Przeliczenie masy na kilogramy

% Obliczenie naprężenia
% Możesz dostosować tę formułę w zależności od sposobu, w jaki masz zdefiniowane kropki
naprezenie = masa_kropki_kg * 9.81 ./ (odleglosci.^2); % Na przykład naprężenie jest odwrotnie proporcjonalne do kwadratu odległości

% Wyświetl wyniki na wykresie
plot(odleglosci, naprezenie);
xlabel('Odległość od czarnej kropki');
ylabel('Naprężenie (Pa)');
title('Naprężenie w funkcji odległości od czarnej kropki w wybranym obszarze');

