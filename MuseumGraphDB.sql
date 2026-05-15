USE master;
GO

DROP DATABASE IF EXISTS MuseumGraphDB;
GO

CREATE DATABASE MuseumGraphDB;
GO

USE MuseumGraphDB;
GO

-- ===== ТАБЛИЦЫ УЗЛОВ =====

CREATE TABLE Exhibit (
    ExhibitID INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Artist NVARCHAR(100),
    Year INT,
    ExhibitType NVARCHAR(50) CHECK (ExhibitType IN ('портрет', 'пейзаж', 'скульптура', 'натюрморт')),
    CONSTRAINT PK_Exhibit PRIMARY KEY (ExhibitID)
) AS NODE;
GO

CREATE TABLE Hall (
    HallID INT NOT NULL,
    HallName NVARCHAR(100) NOT NULL,
    SquareMeters DECIMAL(8,2),
    CONSTRAINT PK_Hall PRIMARY KEY (HallID)
) AS NODE;
GO

CREATE TABLE Guide (
    GuideID INT NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    ExperienceYears INT,
    Language NVARCHAR(50),
    CONSTRAINT PK_Guide PRIMARY KEY (GuideID)
) AS NODE;
GO

-- ===== ТАБЛИЦЫ РЁБЕР =====

CREATE TABLE ExhibitInHall (
    PlacementDate DATE,
    IsPermanent BIT
) AS EDGE;
GO

ALTER TABLE ExhibitInHall ADD CONSTRAINT EC_ExhibitInHall CONNECTION (Exhibit TO Hall);
GO

CREATE TABLE GuideLeadsHall (
    Schedule NVARCHAR(200),
    MaxGroupSize INT
) AS EDGE;
GO

ALTER TABLE GuideLeadsHall ADD CONSTRAINT EC_GuideLeadsHall CONNECTION (Guide TO Hall);
GO

CREATE TABLE GuideKnowsExhibit (
    KnowledgeLevel NVARCHAR(20) CHECK (KnowledgeLevel IN ('основное', 'детальное', 'экспертное')),
    LastUpdated DATE
) AS EDGE;
GO

ALTER TABLE GuideKnowsExhibit ADD CONSTRAINT EC_GuideKnowsExhibit CONNECTION (Guide TO Exhibit);
GO

-- ===== ЗАПОЛНЕНИЕ ТАБЛИЦ УЗЛОВ (все ID от 1 до 10) =====

INSERT INTO Exhibit (ExhibitID, Name, Artist, Year, ExhibitType) VALUES
(1, 'Мона Лиза', 'Леонардо да Винчи', 1503, 'портрет'),
(2, 'Давид', 'Микеланджело', 1504, 'скульптура'),
(3, 'Подсолнухи', 'Ван Гог', 1888, 'натюрморт'),
(4, 'Утро в сосновом лесу', 'Шишкин', 1889, 'пейзаж'),
(5, 'Девятый вал', 'Айвазовский', 1850, 'пейзаж'),
(6, 'Мыслитель', 'Роден', 1902, 'скульптура'),
(7, 'Тайная вечеря', 'Леонардо да Винчи', 1498, 'портрет'),
(8, 'Звёздная ночь', 'Ван Гог', 1889, 'пейзаж'),
(9, 'Венера Милосская', 'Александрос Антиохский', 130, 'скульптура'),
(10, 'Иван Грозный и сын его Иван', 'Репин', 1885, 'портрет');
GO

INSERT INTO Hall (HallID, HallName, SquareMeters) VALUES
(1, 'Зал итальянского Ренессанса', 250.50),
(2, 'Зал скульптуры', 180.00),
(3, 'Зал голландской живописи', 210.75),
(4, 'Зал русского пейзажа', 195.30),
(5, 'Зал маринистов', 175.20),
(6, 'Зал античного искусства', 220.00),
(7, 'Зал импрессионистов', 200.50),
(8, 'Зал религиозной живописи', 185.40),
(9, 'Зал реализма', 190.00),
(10, 'Временная выставка', 300.00);
GO

INSERT INTO Guide (GuideID, FullName, ExperienceYears, Language) VALUES
(1, 'Анна Иванова', 5, 'русский, английский'),
(2, 'Пётр Смирнов', 12, 'русский, французский'),
(3, 'Елена Козлова', 3, 'русский, немецкий'),
(4, 'Михаил Волков', 8, 'русский, испанский, английский'),
(5, 'Ольга Новикова', 15, 'русский, итальянский'),
(6, 'Дмитрий Морозов', 2, 'русский, китайский'),
(7, 'Татьяна Кузнецова', 7, 'русский, английский, французский'),
(8, 'Игорь Соколов', 10, 'русский, немецкий, английский'),
(9, 'Наталья Павлова', 4, 'русский, японский'),
(10, 'Сергей Васильев', 6, 'русский, английский');
GO

DECLARE @from_node NVARCHAR(1000);
DECLARE @to_node NVARCHAR(1000);

-- Мона Лиза (1) -> Зал итальянского Ренессанса (1)
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 1);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 1);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2010-05-01', 1);

-- Давид (2) -> Зал скульптуры (2)
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 2);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 2);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2005-03-15', 1);

-- Подсолнухи (3) -> Зал голландской живописи (3)
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 3);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 3);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2008-11-20', 1);

-- Утро в сосновом лесу (4) -> Зал русского пейзажа (4)
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 4);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 4);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2012-07-10', 1);

-- Девятый вал (5) -> Зал маринистов (5)
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 5);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 5);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2009-06-25', 1);

-- Мыслитель (6) -> Зал скульптуры (2)
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 6);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 2);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2011-04-12', 1);

-- Тайная вечеря (7) -> Зал религиозной живописи (8)
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 7);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 8);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2013-08-30', 1);

-- Звёздная ночь (8) -> Зал импрессионистов (7)
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 8);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 7);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2014-12-01', 1);

-- Венера Милосская (9) -> Зал античного искусства (6)
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 9);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 6);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2007-10-18', 1);

-- Иван Грозный (10) -> Зал реализма (9)
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 10);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 9);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2016-02-20', 1);

-- Девятый вал (5) -> Временная выставка (10) [временная]
SET @from_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 5);
SET @to_node = (SELECT $node_id FROM Hall WHERE HallID = 10);
INSERT INTO ExhibitInHall ($from_id, $to_id, PlacementDate, IsPermanent) VALUES (@from_node, @to_node, '2025-01-15', 0);
GO

-- ===== ЗАПОЛНЕНИЕ ТАБЛИЦЫ РЁБЕР GuideLeadsHall =====

DECLARE @guide_node NVARCHAR(1000);
DECLARE @hall_node NVARCHAR(1000);

-- Анна Иванова (1) -> Зал итальянского Ренессанса (1)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 1);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 1);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'пн,ср,пт 10:00-12:00', 15);

-- Анна Иванова (1) -> Зал реализма (9)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 1);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 9);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'вт,чт 14:00-16:00', 12);

-- Пётр Смирнов (2) -> Зал скульптуры (2)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 2);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 2);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'ср,пт,сб 11:00-13:00', 20);

-- Елена Козлова (3) -> Зал голландской живописи (3)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 3);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 3);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'пн,чт 15:00-17:00', 10);

-- Михаил Волков (4) -> Зал русского пейзажа (4)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 4);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 4);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'вт,ср,пт 12:00-14:00', 18);

-- Ольга Новикова (5) -> Зал античного искусства (6)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 5);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 6);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'пн,сб,вс 10:00-11:30', 25);

-- Дмитрий Морозов (6) -> Временная выставка (10)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 6);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 10);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'ср,чт,пт 16:00-18:00', 8);

-- Татьяна Кузнецова (7) -> Зал импрессионистов (7)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 7);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 7);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'вт,чт,сб 13:00-15:00', 15);

-- Игорь Соколов (8) -> Зал маринистов (5)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 8);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 5);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'пн,ср,пт 09:00-11:00', 12);

-- Наталья Павлова (9) -> Зал религиозной живописи (8)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 9);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 8);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'вт,чт 11:00-13:00', 10);

-- Сергей Васильев (10) -> Зал итальянского Ренессанса (1)
SET @guide_node = (SELECT $node_id FROM Guide WHERE GuideID = 10);
SET @hall_node = (SELECT $node_id FROM Hall WHERE HallID = 1);
INSERT INTO GuideLeadsHall ($from_id, $to_id, Schedule, MaxGroupSize) VALUES (@guide_node, @hall_node, 'сб,вс 14:00-16:00', 20);
GO

-- ===== ЗАПОЛНЕНИЕ ТАБЛИЦЫ РЁБЕР GuideKnowsExhibit =====

DECLARE @guide_node2 NVARCHAR(1000);
DECLARE @exhibit_node NVARCHAR(1000);

-- Анна Иванова (1) -> Мона Лиза (1)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 1);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 1);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'экспертное', '2025-01-10');

-- Анна Иванова (1) -> Иван Грозный (10)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 1);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 10);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'детальное', '2025-02-01');

-- Пётр Смирнов (2) -> Давид (2)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 2);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 2);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'экспертное', '2024-12-15');

-- Пётр Смирнов (2) -> Мыслитель (6)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 2);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 6);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'экспертное', '2025-01-20');

-- Елена Козлова (3) -> Подсолнухи (3)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 3);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 3);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'детальное', '2025-01-05');

-- Елена Козлова (3) -> Звёздная ночь (8)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 3);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 8);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'основное', '2024-11-10');

-- Михаил Волков (4) -> Утро в сосновом лесу (4)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 4);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 4);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'экспертное', '2025-02-10');

-- Ольга Новикова (5) -> Венера Милосская (9)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 5);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 9);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'экспертное', '2025-01-25');

-- Ольга Новикова (5) -> Давид (2)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 5);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 2);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'детальное', '2024-12-05');

-- Дмитрий Морозов (6) -> Девятый вал (5)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 6);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 5);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'основное', '2025-02-14');

-- Татьяна Кузнецова (7) -> Звёздная ночь (8)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 7);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 8);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'экспертное', '2025-01-18');

-- Игорь Соколов (8) -> Девятый вал (5)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 8);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 5);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'детальное', '2025-01-30');

-- Наталья Павлова (9) -> Тайная вечеря (7)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 9);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 7);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'экспертное', '2025-02-05');

-- Сергей Васильев (10) -> Мона Лиза (1)
SET @guide_node2 = (SELECT $node_id FROM Guide WHERE GuideID = 10);
SET @exhibit_node = (SELECT $node_id FROM Exhibit WHERE ExhibitID = 1);
INSERT INTO GuideKnowsExhibit ($from_id, $to_id, KnowledgeLevel, LastUpdated) VALUES (@guide_node2, @exhibit_node, 'основное', '2025-01-12');
GO



--Найти всех гидов, которые водят экскурсии по залам, где выставлены экспонаты Леонардо да Винчи.
SELECT 
    g.FullName AS GuideName,
    g.ExperienceYears,
    h.HallName,
    e.Name AS ExhibitName,
    e.Artist
FROM Guide g, 
     GuideLeadsHall glh, 
     Hall h, 
     ExhibitInHall eih, 
     Exhibit e
WHERE MATCH(g-(glh)->h<-(eih)-e)
  AND e.Artist = 'Леонардо да Винчи'
ORDER BY g.FullName, h.HallName;



--Найти всех гидов (кроме Анны Ивановой), которые знают экспонаты, выставленные в тех же залах, где работает гид Анна Иванова.
SELECT DISTINCT
    other_guide.FullName AS GuideName,
    other_guide.ExperienceYears,
    e.Name AS ExhibitName,
    h.HallName,
    gke.KnowledgeLevel
FROM Guide ann,
     GuideLeadsHall glh_ann,
     Hall h,
     ExhibitInHall eih,
     Exhibit e,
     GuideKnowsExhibit gke,
     Guide other_guide
WHERE MATCH(ann-(glh_ann)->h<-(eih)-e<-(gke)-other_guide)
  AND ann.FullName = 'Анна Иванова'
  AND other_guide.FullName != 'Анна Иванова'
ORDER BY other_guide.FullName, e.Name;


-- Найти все скульптуры и гидов, которые их знают (с информацией о залах)
SELECT 
    e.Name AS SculptureName,
    e.Artist,
    e.Year,
    g.FullName AS GuideName,
    g.ExperienceYears,
    gke.KnowledgeLevel,
    h.HallName AS HallWhereGuideWorks,
    glh.Schedule
FROM Exhibit e,
     GuideKnowsExhibit gke,
     Guide g,
     GuideLeadsHall glh,
     Hall h
WHERE MATCH(e<-(gke)-g-(glh)->h)
  AND e.ExhibitType = 'скульптура'
ORDER BY e.Name, g.FullName;



-- Найти пары гидов, которые работают в одном зале и оба знают хотя бы один экспонат из этого зала
SELECT 
    g1.FullName AS FirstGuide,
    g2.FullName AS SecondGuide,
    h.HallName,
    e.Name AS CommonExhibit,
    gke1.KnowledgeLevel AS FirstGuideKnowledge,
    gke2.KnowledgeLevel AS SecondGuideKnowledge
FROM Guide g1,
     Guide g2,
     GuideLeadsHall glh1,
     GuideLeadsHall glh2,
     Hall h,
     ExhibitInHall eih,
     Exhibit e,
     GuideKnowsExhibit gke1,
     GuideKnowsExhibit gke2
WHERE MATCH(g1-(glh1)->h<-(glh2)-g2 AND g1-(gke1)->e<-(gke2)-g2 AND h<-(eih)-e)
  AND g1.GuideID < g2.GuideID
ORDER BY h.HallName, e.Name, g1.FullName;


-- Найти гидов со знанием экспонатов на временных выставках
SELECT 
    g.FullName AS GuideName,
    g.ExperienceYears,
    e.Name AS ExhibitName,
    e.ExhibitType,
    h.HallName,
    eih.IsPermanent,
    eih.PlacementDate,
    glh.Schedule,
    glh.MaxGroupSize,
    gke.KnowledgeLevel
FROM Guide g,
     GuideLeadsHall glh,
     Hall h,
     ExhibitInHall eih,
     Exhibit e,
     GuideKnowsExhibit gke
WHERE MATCH(g-(glh)->h<-(eih)-e<-(gke)-g)
  AND eih.IsPermanent = 0
ORDER BY g.FullName, e.Name;


-- Кратчайший путь от гида к экспонатам
SELECT g.FullName AS StartGuide, STRING_AGG(h.HallName, ' -> ')
       WITHIN GROUP (GRAPH PATH) AS HallPath,
    LAST_VALUE(e.Name)
       WITHIN GROUP (GRAPH PATH) AS FinalExhibit
FROM Guide g,
     GuideLeadsHall FOR PATH glh,
     Hall FOR PATH h,
     ExhibitInHall FOR PATH eih,
     Exhibit FOR PATH e
WHERE MATCH(
    SHORTEST_PATH(
        g(-(glh)->h<-(eih)-e)+
    )
)
AND g.FullName = 'Анна Иванова';


-- Кратчайший путь между гидами через экспонаты

SELECT
    g1.FullName AS StartGuide,
    STRING_AGG(e.Name, ' -> ')
        WITHIN GROUP (GRAPH PATH) AS ExhibitPath,
    LAST_VALUE(g2.FullName)
        WITHIN GROUP (GRAPH PATH) AS EndGuide
FROM Guide g1,
     GuideKnowsExhibit FOR PATH gke1,
     GuideKnowsExhibit FOR PATH gke2,
     Exhibit FOR PATH e,
     Guide FOR PATH g2
WHERE MATCH(
    SHORTEST_PATH(
        g1(-(gke1)->e<-(gke2)-g2){1,5}
    )
)
AND g1.FullName = 'Анна Иванова';




-- Показать все экспонаты и залы, где они находятся
SELECT 
    e.Name AS ExhibitName,
    h.HallName AS HallName,
    CONCAT('exhibit', e.ExhibitID) AS [Source image name],
    CONCAT('hall', h.HallID) AS [Target image name],
    eih.PlacementDate,
    CASE 
        WHEN eih.IsPermanent = 1 THEN 'Постоянная'
        ELSE 'Временная'
    END AS PlacementType,
    CONCAT(
        'Размещён: ', FORMAT(eih.PlacementDate, 'dd.MM.yyyy'),
        ' (', CASE WHEN eih.IsPermanent = 1 THEN 'постоянно' ELSE 'временно' END, ')'
    ) AS [Label]
FROM Exhibit e, ExhibitInHall eih, Hall h
WHERE MATCH(e-(eih)->h)
ORDER BY h.HallName, e.Name;


-- Показать гидов и залы, где они проводят экскурсии
SELECT 
    g.FullName AS GuideName,
    g.ExperienceYears,
    h.HallName AS HallName,
    CONCAT('guide', g.GuideID) AS [Source image name],
    CONCAT('hall', h.HallID) AS [Target image name],
    glh.Schedule,
    CONCAT(
        'Расписание: ', glh.Schedule,
        ' | Группа до ', glh.MaxGroupSize, ' чел.'
    ) AS [Label]
FROM Guide g, GuideLeadsHall glh, Hall h
WHERE MATCH(g-(glh)->h)
ORDER BY g.FullName, h.HallName;




-- Показать гидов и экспонаты, которые они знают
SELECT 
    g.FullName AS GuideName,
    e.Name AS ExhibitName,
    CONCAT('guide', g.GuideID) AS [Source image name],
    CONCAT('exhibit', e.ExhibitID) AS [Target image name],
    gke.KnowledgeLevel,
    CONCAT(
        'Уровень знаний: ', gke.KnowledgeLevel,
        ' (обновлено: ', FORMAT(gke.LastUpdated, 'dd.MM.yyyy'), ')'
    ) AS [Label]
FROM Guide g, GuideKnowsExhibit gke, Exhibit e
WHERE MATCH(g-(gke)->e)
ORDER BY g.FullName, e.Name;


SELECT @@SERVERNAME