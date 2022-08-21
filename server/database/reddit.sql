-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost:3306
-- Время создания: Авг 22 2022 г., 00:36
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
        
    	GROUP_CONCAT(DISTINCT p_message.p_message) prev_message,
        
    	GROUP_CONCAT(DISTINCT n_message.n_message) next_message,
        
       	IF(
            COUNT(message_reward.quantity) = 0, NULL,        
        	JSON_ARRAYAGG(message_reward.quantity)
        )	reward
        
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
         
     		'all_count', COUNT(message_reward.message_id),
         
     		'reward', message_reward.reward
            
     )	quantity
     
     FROM message_reward
     
     GROUP BY
     
     	message_reward.message_id, 
     	
     	message_reward.reward)
    
    	message_reward
    
    ON message_reward.message_id = post_message.id
    
    WHERE
    
    post_message.post_id = value_post_id
    
    GROUP BY
    
    post_message.id
    
    ORDER BY post_message.id ASC;
    
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
(1, 1, 2);

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
(1, 1, 1, '2022-08-18 01:23:15', 'fake_reddit start', 'fake');

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

-- --------------------------------------------------------

--
-- Структура таблицы `post_like`
--

CREATE TABLE `post_like` (
  `user_id` int NOT NULL,
  `post_id` int NOT NULL,
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
(2, 1, 1, 'real:?');

-- --------------------------------------------------------

--
-- Структура таблицы `post _reward`
--

CREATE TABLE `post _reward` (
  `post_id` int NOT NULL,
  `reward` char(55) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `post_video`
--

CREATE TABLE `post_video` (
  `post_id` int NOT NULL,
  `video_sorce` char(255) NOT NULL,
  `description` char(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
(1, 2, 1);

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
  ADD KEY `reddit_group` (`reddit_group_id`);

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
  ADD KEY `post_id` (`post_id`);

--
-- Индексы таблицы `post_message`
--
ALTER TABLE `post_message`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_login` (`user_id`);

--
-- Индексы таблицы `post _reward`
--
ALTER TABLE `post _reward`
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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `post`
--
ALTER TABLE `post`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `post_img`
--
ALTER TABLE `post_img`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `post_message`
--
ALTER TABLE `post_message`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `p_message`
--
ALTER TABLE `p_message`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  ADD CONSTRAINT `post_like_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `post_like_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `post_message`
--
ALTER TABLE `post_message`
  ADD CONSTRAINT `post_message_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `post_message_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `post _reward`
--
ALTER TABLE `post _reward`
  ADD CONSTRAINT `post _reward_ibfk_1` FOREIGN KEY (`reward`) REFERENCES `rewards` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `post _reward_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
