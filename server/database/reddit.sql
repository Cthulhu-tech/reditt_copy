-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost:3306
-- Время создания: Авг 23 2022 г., 11:54
-- Версия сервера: 8.0.30-0ubuntu0.20.04.2
-- Версия PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `reddit`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`thrackerzod`@`localhost` PROCEDURE `sp_create_post` (IN `user_id_value` INT(11), IN `reddit_group_value` INT(11), IN `title_value` CHAR(55), IN `description_value` VARCHAR(535))  NO SQL
BEGIN
	INSERT INTO post 
    	(post.user_id, post.reddit_group_id, post.create_date, post.title, post.description)
	VALUES 
    	(user_id_value, reddit_group_value, now(),title_value, description_value);
    INSERT INTO post_like (
        post_like.user_id, post_like.post_title, post_like.value)
    VALUES
    	(user_id_value, title_value, 1);
END$$

CREATE DEFINER=`thrackerzod`@`localhost` PROCEDURE `sp_dislike_message` (IN `user_id_value` INT(11), IN `messsage_id_value` INT(11))  NO SQL
BEGIN

 SET @USER_FIND = (SELECT case when COUNT(user.id) = 1 THEN 'FIND' ELSE 'ERROR' 
                END USER_FIND FROM user WHERE user.id = user_id_value);

     
IF (@USER_FIND = 'FIND') THEN
     
     SET @OUTPUT = (SELECT case when COUNT(message_like.message_id) = 0 THEN 'OK' ELSE 'ERROR' 
                    END OUTPUT FROM message_like WHERE 
     message_like.user_id = user_id_value AND message_like.message_id = messsage_id_value);

    IF (@OUTPUT = 'OK') THEN
        INSERT INTO message_like
        (message_like.message_id, 
         message_like.user_id, 
         message_like.value)
        VALUES
        (messsage_id_value, 
         user_id_value,
        -1);
    ELSE
        DELETE FROM message_like 
        WHERE 
        message_like.user_id = user_id_value
        AND
        message_like.message_id = messsage_id_value;
    END IF;
     
END IF;
     
END$$

CREATE DEFINER=`thrackerzod`@`localhost` PROCEDURE `sp_dislike_post` (IN `user_id_value` INT(11), IN `post_title_value` CHAR(55))  NO SQL
BEGIN

 SET @USER_FIND = (SELECT case when COUNT(user.id) = 1 THEN 'FIND' ELSE 'ERROR' 
                END USER_FIND FROM user WHERE user.id = user_id_value);

     
IF (@USER_FIND = 'FIND') THEN

    SET @OUTPUT =
        (SELECT case when  
         COUNT(post_like.user_id) = 0 
         THEN 'OK' ELSE 'ERROR' END OUTPUT
        FROM post_like
        WHERE post_like.user_id = user_id_value 
        and post_like.post_title = post_title_value);

        IF (@output = 'OK') THEN
            INSERT INTO post_like
            (post_like.post_title, 
             post_like.user_id, 
             post_like.value)
            VALUES
            (post_title_value, 
             user_id_value,
            -1);
        ELSE
            DELETE FROM post_like 
            WHERE 
            post_like.user_id = user_id_value
            AND
            post_like.post_title = post_title_value;
        END IF;
END IF;

END$$

CREATE DEFINER=`thrackerzod`@`localhost` PROCEDURE `sp_find_user_in_login` (IN `value_login` VARCHAR(255))  NO SQL
BEGIN

	SELECT 
    
    	COUNT(*) count,
        
        user.id id
    
    FROM user
    
    WHERE login = value_login
    
    GROUP BY user.id;

END$$

CREATE DEFINER=`thrackerzod`@`localhost` PROCEDURE `sp_get_all_message_in_post` (IN `value_post_id` INT(11))  NO SQL
BEGIN

	SELECT
    
    	post_message.id message_id,
        
        GROUP_CONCAT(DISTINCT user.login) user,
        
    	post_message.message message,
        
        CONCAT('[',
        GROUP_CONCAT(DISTINCT p_message.p_message),
        ']')
        
        prev_message,
        
      	CONCAT('[',
        GROUP_CONCAT(DISTINCT n_message.n_message),
        ']')
        
        next_message,

       	IF(
       COUNT(message_reward.quantity) = 0, NULL,        		
       CONCAT('[',
       GROUP_CONCAT(DISTINCT message_reward.quantity),
         ']')
        )	reward,
        
       IF(COUNT(message_like.message_id) = 0, 0,        		
       SUM(DISTINCT message_like.value)) message_value
        
    FROM post_message
    
    LEFT JOIN p_message
    
    ON post_message.id = p_message.message_id
    
    LEFT JOIN n_message
    
    ON post_message.id = n_message.message_id
    
    LEFT JOIN user
    
    ON user.id = post_message.user_id
    
    LEFT JOIN
    
    (SELECT 
     message_reward.message_id message_id,
     
     	JSON_OBJECT(
         
     		'all_count',
            COUNT(message_reward.message_id),
         
     		'reward',
             message_reward.reward
            
     )	quantity
     
     FROM message_reward 
     
     GROUP BY
     
     	message_reward.message_id, 
     	
     	message_reward.reward)
    
    	message_reward
    
    ON message_reward.message_id = post_message.id
    
    LEFT JOIN message_like
    
    ON message_like.message_id = post_message.id
    
    WHERE
    
    post_message.post_id = value_post_id
    
    GROUP BY
    
    post_message.id,
    
    post_message.post_id
    
    ORDER BY 
    
    post_message.id,
    
    post_message.post_id
    
    ASC;
    
END$$

CREATE DEFINER=`thrackerzod`@`localhost` PROCEDURE `sp_get_best_post` (IN `page` INT(11))  NO SQL
BEGIN

	SELECT
        
        GROUP_CONCAT(
            DISTINCT 
            (SELECT user.login 
             FROM user 
             WHERE 
             user.id = post.user_id)) user,
             
       post.title title,
       
       post.description description,
        

        CONCAT('[',
        GROUP_CONCAT(DISTINCT post_img.source),
        ']') 
        
        img,
        
        CONCAT('[',
        GROUP_CONCAT(DISTINCT post_video.video_sorce),
        ']') 
        
        video,
        
       IF(
       COUNT(post_reward.post_id) = 0, NULL,        		
       CONCAT('[',
       GROUP_CONCAT(DISTINCT post_reward.quantity),
         ']')
        )	reward,
        
       IF(COUNT(post_like.user_id) = 0, 0,        		
       SUM(DISTINCT post_like.value)) post_value
        
    FROM post
    
    LEFT JOIN  post_video
    
    ON post_video.post_id = post.id
    
    LEFT JOIN post_img
    
    ON post_img.post_id = post.id
    
    LEFT JOIN post_like
    
    ON post.title = post_like.post_title
    
    LEFT JOIN
    
    (SELECT
     
     post_reward.post_id post_id,
     
     	JSON_OBJECT(
         
     		'all_count',
            
            COUNT(post_reward.post_id),
         
     		'reward',
            
             post_reward.reward
            
     )	quantity
     
     FROM post_reward 
     
     GROUP BY
     
     	post_reward.post_id, 
     	
     	post_reward.reward)
    
    	post_reward
        
	ON post_reward.post_id = post.id
    
    GROUP BY
    
    	post.id,
        
        post.user_id
        
    ORDER BY 
    
    	post.id,
        
        post.user_id
    
    ASC;
    
END$$

CREATE DEFINER=`thrackerzod`@`localhost` PROCEDURE `sp_get_like_message` (IN `messsage_id_value` INT(11))  NO SQL
BEGIN
	SELECT 
    	IF(
           COUNT(message_like.value) = 0, 
           0, 
           SUM(message_like.value)
        ) value,
        messsage_id_value id
    FROM
    	message_like
    WHERE
    	message_like.message_id = messsage_id_value;
END$$

CREATE DEFINER=`thrackerzod`@`localhost` PROCEDURE `sp_like_message` (IN `user_id_value` INT(11), IN `messsage_id_value` INT(11))  NO SQL
BEGIN

 SET @USER_FIND = (SELECT case when COUNT(user.id) = 1 THEN 'FIND' ELSE 'ERROR' 
                END USER_FIND FROM user WHERE user.id = user_id_value);

     
IF (@USER_FIND = 'FIND') THEN

    SET @OUTPUT =
        (SELECT case when  
         COUNT(message_like.message_id) = 0 
         THEN 'OK' ELSE 'ERROR' END OUTPUT
        FROM message_like
        WHERE message_like.user_id = user_id_value 
        and message_like.message_id = messsage_id_value);

        IF (@output = 'OK') THEN
            INSERT INTO message_like
            (message_like.message_id, 
             message_like.user_id, 
             message_like.value)
            VALUES
            (messsage_id_value, 
             user_id_value,
            1);
        ELSE
            DELETE FROM message_like 
            WHERE 
            message_like.user_id = user_id_value
            AND
            message_like.message_id = messsage_id_value;
        END IF;
END IF;

END$$

CREATE DEFINER=`thrackerzod`@`localhost` PROCEDURE `sp_like_post` (IN `user_id_value` INT(11), IN `post_title_value` CHAR(55))  NO SQL
BEGIN

 SET @USER_FIND = (SELECT case when COUNT(user.id) = 1 THEN 'FIND' ELSE 'ERROR' 
                END USER_FIND FROM user WHERE user.id = user_id_value);

     
IF (@USER_FIND = 'FIND') THEN

    SET @OUTPUT =
        (SELECT case when  
         COUNT(post_like.user_id) = 0 
         THEN 'OK' ELSE 'ERROR' END OUTPUT
        FROM post_like
        WHERE post_like.user_id = user_id_value 
        and post_like.post_title = post_title_value);

        IF (@output = 'OK') THEN
            INSERT INTO post_like
            (post_like.post_title, 
             post_like.user_id, 
             post_like.value)
            VALUES
            (post_title_value, 
             user_id_value,
            1);
        ELSE
            DELETE FROM post_like 
            WHERE 
            post_like.user_id = user_id_value
            AND
            post_like.post_title = post_title_value;
        END IF;
END IF;

END$$

CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `sp_save_or_delete_post_in_id` (IN `post_id` INT(11), IN `user_id` INT)  NO SQL
BEGIN
SET @OUTPUT =
	(SELECT case when  
     COUNT(save_post.post) = 0 
     THEN 'OK' ELSE 'ERROR' END OUTPUT
	FROM save_post
 	WHERE save_post.post = post_id 
 	and save_post.user = user_id);

    IF (@output = 'OK') THEN
        INSERT INTO save_post
        (save_post.post, save_post.user)
        VALUES
        (post_id, user_id);
    ELSE
        DELETE FROM save_post 
        WHERE 
        save_post.post = post_id
        AND
        save_post.user = user_id;
    END IF;
END$$

CREATE DEFINER=`thrackerzod`@`localhost` PROCEDURE `sp_set_message_in_post` (IN `user_id_value` INT(11), IN `message_value` CHAR(55), IN `post_id_value` INT(11), IN `next_message_value` INT(11), IN `prev_message_value` INT(11))  NO SQL
BEGIN
	SET @OUTPUT =
	(SELECT case when  
     COUNT(*) = 1 
     THEN 'OK' ELSE 'ERROR' END OUTPUT
	FROM post
 	WHERE post.id = post_id_value);
    
    SET @NEXT_VALUE = next_message_value;
    SET @PREV_VALUE = prev_message_value;
    
    IF (@output = 'OK') THEN
        INSERT INTO post_message
        (post_id, user_id, message)
        VALUES
        (post_id_value, user_id_value, message_value);
        
        IF (@NEXT_VALUE > 0) THEN
        	INSERT INTO n_message
            (n_message.message_id, n_message.n_message)
            VALUES
            ((SELECT LAST_INSERT_ID()), next_message_value);
        END IF;
        IF (@PREV_VALUE > 0) THEN
            INSERT INTO p_message
            (p_message.message_id, p_message.p_message)
            VALUES
            ((SELECT LAST_INSERT_ID()), prev_message_value);
        END IF;
    INSERT INTO message_like 
        (message_like.message_id, 
         message_like.user_id, 
         message_like.value)
    VALUES
    	((SELECT LAST_INSERT_ID()),
        user_id_value, 
        1);
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `group_reddit`
--

CREATE TABLE `group_reddit` (
  `id` int NOT NULL,
  `avatars` char(55) NOT NULL,
  `title` char(55) NOT NULL,
  `description` char(255) NOT NULL,
  `background` char(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `group_reddit`
--

INSERT INTO `group_reddit` (`id`, `avatars`, `title`, `description`, `background`) VALUES
(1, 'fake-reddit-avatars.png', 'fake_reddit', 'wow! it\'s fake reddit.', 'fake-reddit.png');

-- --------------------------------------------------------

--
-- Структура таблицы `message_like`
--

CREATE TABLE `message_like` (
  `message_id` int NOT NULL,
  `user_id` int NOT NULL,
  `value` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `message_like`
--

INSERT INTO `message_like` (`message_id`, `user_id`, `value`) VALUES
(1, 1, -1),
(3, 1, 1),
(13, 1, -1);

-- --------------------------------------------------------

--
-- Структура таблицы `message_reward`
--

CREATE TABLE `message_reward` (
  `message_id` int NOT NULL,
  `reward` char(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `message_reward`
--

INSERT INTO `message_reward` (`message_id`, `reward`) VALUES
(1, 'cool'),
(1, 'super'),
(1, 'cool');

-- --------------------------------------------------------

--
-- Структура таблицы `n_message`
--

CREATE TABLE `n_message` (
  `id` int NOT NULL,
  `message_id` int NOT NULL,
  `n_message` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `n_message`
--

INSERT INTO `n_message` (`id`, `message_id`, `n_message`) VALUES
(1, 1, 2),
(2, 1, 3);

-- --------------------------------------------------------

--
-- Структура таблицы `post`
--

CREATE TABLE `post` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `reddit_group_id` int NOT NULL,
  `create_date` timestamp NOT NULL,
  `title` char(55) NOT NULL,
  `description` varchar(535) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `post`
--

INSERT INTO `post` (`id`, `user_id`, `reddit_group_id`, `create_date`, `title`, `description`) VALUES
(1, 1, 1, '2022-08-18 01:23:15', 'fake_reddit start', 'fake'),
(3, 1, 1, '2022-08-23 04:47:39', 'test', 'test');

-- --------------------------------------------------------

--
-- Структура таблицы `post_img`
--

CREATE TABLE `post_img` (
  `id` int NOT NULL,
  `post_id` int NOT NULL,
  `description` char(55) NOT NULL,
  `source` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `post_img`
--

INSERT INTO `post_img` (`id`, `post_id`, `description`, `source`) VALUES
(1, 1, 'post-fake.png', 'post-fake.png'),
(2, 1, 'post-fake1.png', 'post-fake1.png'),
(3, 1, 'post-fake2.png', 'post-fake2.png');

-- --------------------------------------------------------

--
-- Структура таблицы `post_like`
--

CREATE TABLE `post_like` (
  `user_id` int NOT NULL,
  `post_title` char(55) NOT NULL,
  `value` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `post_message`
--

CREATE TABLE `post_message` (
  `id` int NOT NULL,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `message` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `post_message`
--

INSERT INTO `post_message` (`id`, `post_id`, `user_id`, `message`) VALUES
(1, 1, 1, 'it\'s cool!'),
(2, 1, 1, 'real:?'),
(3, 1, 1, 'test'),
(5, 3, 1, 'hello!'),
(6, 3, 1, 'hello!'),
(7, 3, 1, 'work!'),
(13, 3, 1, 'hello, it\'s work!');

-- --------------------------------------------------------

--
-- Структура таблицы `post_reward`
--

CREATE TABLE `post_reward` (
  `post_id` int NOT NULL,
  `reward` char(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `post_reward`
--

INSERT INTO `post_reward` (`post_id`, `reward`) VALUES
(1, 'super'),
(1, 'cool'),
(1, 'cool'),
(3, 'super');

-- --------------------------------------------------------

--
-- Структура таблицы `post_video`
--

CREATE TABLE `post_video` (
  `post_id` int NOT NULL,
  `video_sorce` char(255) NOT NULL,
  `description` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `post_video`
--

INSERT INTO `post_video` (`post_id`, `video_sorce`, `description`) VALUES
(1, 'video.mp4', 'video.mp4'),
(3, 'video1.mp4', 'video1.mp4');

-- --------------------------------------------------------

--
-- Структура таблицы `p_message`
--

CREATE TABLE `p_message` (
  `id` int NOT NULL,
  `message_id` int NOT NULL,
  `p_message` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `p_message`
--

INSERT INTO `p_message` (`id`, `message_id`, `p_message`) VALUES
(1, 2, 1),
(2, 3, 1),
(3, 7, 6);

-- --------------------------------------------------------

--
-- Структура таблицы `rewards`
--

CREATE TABLE `rewards` (
  `id` int NOT NULL,
  `name` char(55) NOT NULL,
  `user_id` int NOT NULL,
  `img` char(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `rewards`
--

INSERT INTO `rewards` (`id`, `name`, `user_id`, `img`) VALUES
(3, 'cool', 1, 'cool.png'),
(4, 'super', 1, 'super.png');

-- --------------------------------------------------------

--
-- Структура таблицы `save_post`
--

CREATE TABLE `save_post` (
  `post` int NOT NULL,
  `user` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `token`
--

CREATE TABLE `token` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `token` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `login` char(55) NOT NULL,
  `password` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_date` timestamp NOT NULL,
  `confirm` tinyint(1) DEFAULT '0',
  `mail` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `user`
--

INSERT INTO `user` (`id`, `login`, `password`, `create_date`, `confirm`, `mail`) VALUES
(1, 'Admin', '$2a$14$AFzvipzNrWUL7vfnvAt4suNUqEKb9rfTSoSADDWhhTYMM2iHt91C2', '2022-08-18 01:20:03', 1, 'admin@mail.com');

-- --------------------------------------------------------

--
-- Структура таблицы `user_message`
--

CREATE TABLE `user_message` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `user_id_to` int NOT NULL,
  `message` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `group_reddit`
--
ALTER TABLE `group_reddit`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Индексы таблицы `message_like`
--
ALTER TABLE `message_like`
  ADD KEY `message_id` (`message_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `message_reward`
--
ALTER TABLE `message_reward`
  ADD KEY `message_reward_ibfk_1` (`message_id`),
  ADD KEY `message_reward_ibfk_2` (`reward`);

--
-- Индексы таблицы `n_message`
--
ALTER TABLE `n_message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `message_id` (`message_id`),
  ADD KEY `n_message` (`n_message`);

--
-- Индексы таблицы `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `user_login` (`user_id`),
  ADD KEY `reddit_group` (`reddit_group_id`),
  ADD KEY `title` (`title`);

--
-- Индексы таблицы `post_img`
--
ALTER TABLE `post_img`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `post_id` (`post_id`);

--
-- Индексы таблицы `post_like`
--
ALTER TABLE `post_like`
  ADD KEY `user_id` (`user_id`),
  ADD KEY `post_title` (`post_title`);

--
-- Индексы таблицы `post_message`
--
ALTER TABLE `post_message`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_login` (`user_id`);

--
-- Индексы таблицы `post_reward`
--
ALTER TABLE `post_reward`
  ADD KEY `post_id` (`post_id`),
  ADD KEY `reward` (`reward`);

--
-- Индексы таблицы `post_video`
--
ALTER TABLE `post_video`
  ADD KEY `post_id` (`post_id`);

--
-- Индексы таблицы `p_message`
--
ALTER TABLE `p_message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `message_id` (`message_id`),
  ADD KEY `p_message` (`p_message`);

--
-- Индексы таблицы `rewards`
--
ALTER TABLE `rewards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`),
  ADD KEY `id` (`id`),
  ADD KEY `rewards_ibfk_1` (`user_id`);

--
-- Индексы таблицы `save_post`
--
ALTER TABLE `save_post`
  ADD KEY `post` (`post`),
  ADD KEY `user` (`user`);

--
-- Индексы таблицы `token`
--
ALTER TABLE `token`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `user` (`user_id`);

--
-- Индексы таблицы `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `login` (`login`);

--
-- Индексы таблицы `user_message`
--
ALTER TABLE `user_message`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `user_login` (`user_id`),
  ADD KEY `user_login_to` (`user_id_to`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `group_reddit`
--
ALTER TABLE `group_reddit`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `n_message`
--
ALTER TABLE `n_message`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `post`
--
ALTER TABLE `post`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `post_img`
--
ALTER TABLE `post_img`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `post_message`
--
ALTER TABLE `post_message`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `p_message`
--
ALTER TABLE `p_message`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `rewards`
--
ALTER TABLE `rewards`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `token`
--
ALTER TABLE `token`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT для таблицы `user`
--
ALTER TABLE `user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `user_message`
--
ALTER TABLE `user_message`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `message_like`
--
ALTER TABLE `message_like`
  ADD CONSTRAINT `message_like_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `message_like_ibfk_2` FOREIGN KEY (`message_id`) REFERENCES `post_message` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `message_reward`
--
ALTER TABLE `message_reward`
  ADD CONSTRAINT `message_reward_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `post_message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `message_reward_ibfk_2` FOREIGN KEY (`reward`) REFERENCES `rewards` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `n_message`
--
ALTER TABLE `n_message`
  ADD CONSTRAINT `n_message_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `post_message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `n_message_ibfk_2` FOREIGN KEY (`n_message`) REFERENCES `post_message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `post_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `post_ibfk_2` FOREIGN KEY (`reddit_group_id`) REFERENCES `group_reddit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `post_img`
--
ALTER TABLE `post_img`
  ADD CONSTRAINT `post_img_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `post_like`
--
ALTER TABLE `post_like`
  ADD CONSTRAINT `post_like_ibfk_3` FOREIGN KEY (`post_title`) REFERENCES `post` (`title`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `post_like_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `post_message`
--
ALTER TABLE `post_message`
  ADD CONSTRAINT `post_message_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `post_message_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `post_reward`
--
ALTER TABLE `post_reward`
  ADD CONSTRAINT `post_reward_ibfk_1` FOREIGN KEY (`reward`) REFERENCES `rewards` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `post_reward_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `post_video`
--
ALTER TABLE `post_video`
  ADD CONSTRAINT `post_video_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `p_message`
--
ALTER TABLE `p_message`
  ADD CONSTRAINT `p_message_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `post_message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `p_message_ibfk_2` FOREIGN KEY (`p_message`) REFERENCES `post_message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `rewards`
--
ALTER TABLE `rewards`
  ADD CONSTRAINT `rewards_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `save_post`
--
ALTER TABLE `save_post`
  ADD CONSTRAINT `save_post_ibfk_1` FOREIGN KEY (`post`) REFERENCES `post` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `save_post_ibfk_2` FOREIGN KEY (`user`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `token`
--
ALTER TABLE `token`
  ADD CONSTRAINT `token_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `user_message`
--
ALTER TABLE `user_message`
  ADD CONSTRAINT `user_message_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_message_ibfk_2` FOREIGN KEY (`user_id_to`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
