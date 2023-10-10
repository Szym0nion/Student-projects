% Inicjalizacja zmiennych na dane
global wczytaneDane;
global poleTekstowe
global liczbaPodobrazow;
global podobrazy;
global wykres; % Uchwyt do osi wykresu
nazwaPliku = '';

% Tworzenie figury (okna) GUI
figura = figure('Name', 'Moje GUI', 'Position', [100, 100, 1920, 1080]);

% Tworzenie przycisku "Przeglądaj" dla obrazów
przyciskPrzegladaj = uicontrol('Parent', figura, 'Style', 'pushbutton', ...
    'String', 'Przeglądaj Obraz', 'Position', [50, 880, 150, 40]);

% Tworzenie przycisku "Wczytaj i Wyświetl Obraz" na wykresie
przyciskWczytaj = uicontrol('Parent', figura, 'Style', 'pushbutton', ...
    'String', 'Wczytaj i Wyświetl', 'Position', [250, 880, 150, 40]);

% Tworzenie miejsca na wykres (osi)
wykres = axes('Parent', figura, 'Position', [0.03, 0.5, 0.8, 0.4]);

% Wyświetlanie etykiety
etykieta = uicontrol('Parent', figura, 'Style', 'text', ...
    'String', 'Podaj liczbę  podobrazów:', 'Position', [50, 400, 100, 30]);

% Tworzenie pola tekstowego
poleTekstowe = uicontrol('Parent', figura, 'Style', 'edit', ...
    'Position', [160, 400, 100, 20]);

% Tworzenie przycisku "Akceptuj"
przyciskAkceptuj = uicontrol('Parent', figura, 'Style', 'pushbutton', ...
    'String', 'Akceptuj', 'Position', [280, 400, 80, 20]);

% Tworzenie przycisku "Podziel Obraz"
przyciskPodziel = uicontrol('Parent', figura, 'Style', 'pushbutton', ...
    'String', 'Podziel Obraz', 'Position', [50, 360, 120, 30]);

% Tworzenie przycisku "Zlicz Kropki"
przyciskZliczKropki = uicontrol('Parent', figura, 'Style', 'pushbutton', ...
    'String', 'Zlicz Kropki', 'Position', [200, 360, 120, 30]);

% Dodanie funkcji obsługi przycisków
set(przyciskPrzegladaj, 'Callback', @funkcjaPrzegladajObraz);
set(przyciskWczytaj, 'Callback', @funkcjaWczytajObraz);

% Dodanie funkcji obsługi przycisku "Akceptuj"
set(przyciskAkceptuj, 'Callback', @funkcjaAkceptuj);

% Dodanie funkcji obsługi zmiany tekstu w polu tekstowym
set(poleTekstowe, 'Callback', @funkcjaSprawdzTekst);

% Dodanie funkcji obsługi przycisku "Podziel Obraz"
set(przyciskPodziel, 'Callback', @funkcjaPodzielObraz);

% Dodanie funkcji obsługi przycisku "Zlicz Kropki"
set(przyciskZliczKropki, 'Callback', @funkcjaZliczKropki);

% Funkcja obsługi przycisku "Przeglądaj Obraz"
function funkcjaPrzegladajObraz(~, ~)
    global wczytaneDane;
    [nazwaPliku, sciezkaPliku] = uigetfile({'.jpg'; '.png'; '.'}, 'Wybierz plik z obrazem');
    if ~isequal(nazwaPliku, 0)
        pelnaSciezka = fullfile(sciezkaPliku, nazwaPliku);
        % Wczytywanie obrazu z wybranego pliku
        wczytaneDane = imread(pelnaSciezka);
        % Tutaj możesz przetwarzać wczytany obraz lub wyświetlać go na wykresie itp.
        disp(['Wczytano obraz: ' pelnaSciezka]);
    else
        disp('Anulowano wybór pliku.');
    end
end

% Funkcja obsługi przycisku "Wczytaj i Wyświetl Obraz" na wykresie
function funkcjaWczytajObraz(~, ~)
    global wczytaneDane;
    global wykres;
    if ~isempty(wczytaneDane)
        % Wyświetlenie wczytanego obrazu na wykresie
        imshow(wczytaneDane, 'Parent', wykres);
        title(wykres, 'Wczytany obraz');
    else
        disp('Nie wczytano obrazu.');
    end
end


% Funkcja obsługi przycisku "Akceptuj"
function funkcjaAkceptuj(~, ~)
    global poleTekstowe
    % Pobranie tekstu wprowadzonego przez użytkownika z pola tekstowego
    tekst = get(poleTekstowe, 'String');

    % Konwersja tekstu na liczbę (jeśli to możliwe)
    try
        liczba = str2double(tekst);
        if isnan(liczba)
            error('Niepoprawna liczba');
        else
            % Liczba jest poprawna, możesz z nią pracować
            disp(['Wprowadzona liczba: ' num2str(liczba)]);
        end
    catch
        % Wystąpił błąd podczas konwersji na liczbę
        disp('Wprowadzono niepoprawną liczbę.');
    end
end

% Funkcja obsługi zmiany tekstu w polu tekstowym
function funkcjaSprawdzTekst(~, ~)
    global poleTekstowe;
    % Pobranie tekstu wprowadzonego przez użytkownika z pola tekstowego
    tekst = get(poleTekstowe, 'String');

    % Usunięcie wszystkich znaków, które nie są cyframi
    tylkoCyfry = regexprep(tekst, '[^0-9]', '');

    % Aktualizacja zawartości pola tekstowego
    set(poleTekstowe, 'String', tylkoCyfry);
end

% Funkcja obsługi przycisku "Podziel Obraz"
function funkcjaPodzielObraz(~, ~)
    global wczytaneDane;
    global liczbaPodobrazow;
    global poleTekstowe;

    % Pobranie tekstu wprowadzonego przez użytkownika z pola tekstowego
    tekst = get(poleTekstowe, 'String');

    % Konwersja tekstu na liczbę (liczba podobrazów)
    try
        liczbaPodobrazow = str2double(tekst);
        if isnan(liczbaPodobrazow) || liczbaPodobrazow < 1
            error('Niepoprawna liczba podobrazów');
        else
            % Liczba jest poprawna, możesz przeprowadzić podział obrazu
            disp(['Podzielono obraz na ' num2str(liczbaPodobrazow) ' podobrazów.']);

            % Tutaj wykonaj podział obrazu na odpowiednią liczbę podobrazów
            podzielObraz(wczytaneDane, liczbaPodobrazow);
        end
    catch
        % Wystąpił błąd podczas konwersji na liczbę
        disp('Wprowadzono niepoprawną liczbę podobrazów.');
    end
end

% Funkcja do podziału obrazu na określoną liczbę podobrazów
function podzielObraz(obraz, liczbaPodobrazow)
    global wczytaneDane;
    global liczbaPodobrazow;
    global podobrazy;

    % Obliczenie wymiarów podobrazów
    oryginalna_wysokosc = size(obraz, 1);
    oryginalna_szerokosc = size(obraz, 2);
    szerokoscPodobrazu = oryginalna_szerokosc / liczbaPodobrazow;

    % Inicjalizacja komórki na podobrazy
    podobrazy = cell(1, liczbaPodobrazow);

    % Podział obrazu
    for i = 1:liczbaPodobrazow
        % Oblicz współrzędne początkowe i końcowe dla podobrazu
        x_start = 1;
        x_end = oryginalna_wysokosc;
        y_start = round((i - 1) * szerokoscPodobrazu) + 1;
        y_end = round(i * szerokoscPodobrazu);

        % Wytnij podobraz z oryginalnego obrazu
        podobrazy{i} = obraz(x_start:x_end, y_start:y_end);

        % Wyświetl podobraz
        subplot(1, liczbaPodobrazow, i);
        imshow(podobrazy{i});
        title(['Podobraz ' num2str(i)]);
    end
end

function funkcjaZliczKropki(~, ~)
    global wczytaneDane;
    global liczbaPodobrazow;
    global podobrazy;
    global wykres;
    
    if isempty(wczytaneDane)
        disp('Brak wczytanego obrazu.');
        return;
    end

    % Wywołaj funkcję do zliczania kropel na podobrazach
    liczby_kropek_na_podobrazach = zeros(1, liczbaPodobrazow);
    for i = 1:liczbaPodobrazow
        % Przekazujemy pojedynczy podobraz jako argument
        liczby_kropek_na_podobrazach(1, i) = zlicz_czarne_kropki_na_podobrazie(podobrazy{1, i});
    end
    
    %wykres slupkowy
    figura = figure('Name', 'Moje GUI', 'Position', [100, 100, 1920, 1080]);
    wykres = axes('Parent', figura, 'Position', [0.1, 0.5, 0.8, 0.4]);
    bar(liczby_kropek_na_podobrazach,'Parent', wykres);
    xlabel('Numer podobrazu');
    ylabel('Ilosc komorek');
    title('Ilosc kropek, w wybranym podobrazie');
    % Wyświetl wyniki
    disp('Liczba czarnych kropek na podobrazach:');
    disp(liczby_kropek_na_podobrazach);
end
