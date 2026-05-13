-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 29, 2026 at 11:33 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `panels`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(50) NOT NULL,
  `date` datetime NOT NULL,
  `action` varchar(255) CHARACTER SET latin1 NOT NULL,
  `ipaddress` varchar(20) CHARACTER SET latin1 NOT NULL,
  `device_os` varchar(100) CHARACTER SET latin1 NOT NULL,
  `device_client` varchar(100) CHARACTER SET latin1 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `user_id`, `date`, `action`, `ipaddress`, `device_os`, `device_client`) VALUES
(1, 1, '2026-03-28 20:37:09', 'Logout', '::1', 'Google Chrome', 'Web Browser'),
(2, 2, '2026-03-28 20:37:15', 'Website Login', '::1', 'Windows 10 - Chrome', 'Desktop'),
(3, 2, '2026-03-29 11:09:52', 'Logout', '::1', 'Google Chrome', 'Web Browser'),
(4, 1, '2026-03-29 11:10:14', 'Website Login', '::1', 'Windows 10 - Chrome', 'Desktop'),
(5, 1, '2026-03-29 11:53:12', 'Logout', '::1', 'Google Chrome', 'Web Browser'),
(6, 2, '2026-03-29 11:53:18', 'Website Login', '::1', 'Windows 10 - Chrome', 'Desktop'),
(7, 2, '2026-03-29 12:03:17', 'Logout', '::1', 'Google Chrome', 'Web Browser'),
(8, 1, '2026-03-29 12:03:22', 'Website Login', '::1', 'Windows 10 - Chrome', 'Desktop');

-- --------------------------------------------------------

--
-- Table structure for table `ads_api_logs`
--

CREATE TABLE `ads_api_logs` (
  `id` int(11) NOT NULL,
  `app_name` varchar(100) NOT NULL,
  `endpoint` varchar(200) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `request_data` text DEFAULT NULL,
  `response_code` int(3) DEFAULT NULL,
  `created_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `ads_apps`
--

CREATE TABLE `ads_apps` (
  `id` int(11) NOT NULL,
  `app_name` varchar(100) NOT NULL,
  `package_name` varchar(150) NOT NULL,
  `admob_app_id` varchar(100) NOT NULL,
  `banner_ad_id` varchar(100) DEFAULT NULL,
  `interstitial_ad_id` varchar(100) DEFAULT NULL,
  `rewarded_ad_id` varchar(100) DEFAULT NULL,
  `native_advanced_ad_id` varchar(100) DEFAULT NULL,
  `app_open_ad_id` varchar(100) DEFAULT NULL,
  `status` enum('active','inactive','testing') DEFAULT 'active',
  `created_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ads_apps`
--

INSERT INTO `ads_apps` (`id`, `app_name`, `package_name`, `admob_app_id`, `banner_ad_id`, `interstitial_ad_id`, `rewarded_ad_id`, `native_advanced_ad_id`, `app_open_ad_id`, `status`, `created_date`, `updated_date`) VALUES
(6, 'ruzain', 'app.ruzain.pro.vpn', 'ca-app-pub-3616593289334307~8638068144', 'ca-app-pub-3616593289334307/9578231831', 'ca-app-pub-3616593289334307/4111843231', 'ca-app-pub-3616593289334307/9703737808', 'ca-app-pub-3616593289334307/2142594948', 'ca-app-pub-3616593289334307/1593491107', 'active', '2025-11-13 17:36:21', '2026-03-28 16:08:46');

-- --------------------------------------------------------

--
-- Table structure for table `ads_revenue`
--

CREATE TABLE `ads_revenue` (
  `id` int(11) NOT NULL,
  `app_id` int(11) NOT NULL,
  `app_name` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `ad_type` enum('banner','interstitial','rewarded','native_advanced','app_open','all') DEFAULT 'all',
  `revenue` decimal(10,2) DEFAULT 0.00,
  `impressions` int(11) DEFAULT 0,
  `clicks` int(11) DEFAULT 0,
  `ctr` decimal(5,2) DEFAULT 0.00,
  `created_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `anti_ddos`
--

CREATE TABLE `anti_ddos` (
  `id` int(11) NOT NULL,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `ip` varchar(128) NOT NULL DEFAULT '0.0.0.0',
  `timestamp` int(11) NOT NULL,
  `logs_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `application`
--

CREATE TABLE `application` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `link` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `application`
--

INSERT INTO `application` (`id`, `name`, `link`, `date`, `description`, `status`) VALUES
(1, 'Android App', 'https://play.google.com/store/apps', '2025-11-14 18:12:06', 'Android VPN Application', 'active'),
(2, 'iOS App', 'https://apps.apple.com/', '2025-11-14 18:12:06', 'iOS VPN Application', 'active'),
(3, 'Windows App', 'https://example.com/windows', '2025-11-14 18:12:06', 'Windows VPN Client', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE `applications` (
  `id` int(11) NOT NULL,
  `app_title` varchar(155) CHARACTER SET latin1 NOT NULL,
  `app_version` varchar(11) CHARACTER SET latin1 NOT NULL,
  `app_website` varchar(155) CHARACTER SET latin1 NOT NULL,
  `logo` varchar(55) CHARACTER SET latin1 NOT NULL,
  `app_description` varchar(55) CHARACTER SET latin1 NOT NULL,
  `filename` varchar(255) CHARACTER SET latin1 NOT NULL,
  `date_uploaded` datetime NOT NULL DEFAULT current_timestamp(),
  `downloads` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `app_notices`
--

CREATE TABLE `app_notices` (
  `id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `notice_type` enum('info','warning','success','error','update') COLLATE utf8mb4_unicode_ci DEFAULT 'info',
  `is_active` tinyint(1) DEFAULT 1,
  `show_button` tinyint(1) DEFAULT 0,
  `button_text` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `button_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `min_version` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_version` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `priority` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attention`
--

CREATE TABLE `attention` (
  `id` int(11) NOT NULL,
  `attention_msg` text NOT NULL,
  `attention_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bandwidth_logs`
--

CREATE TABLE `bandwidth_logs` (
  `id` int(11) NOT NULL,
  `server` text NOT NULL,
  `server_ip` text NOT NULL,
  `server_port` text NOT NULL,
  `since_connected` text NOT NULL,
  `username` text NOT NULL,
  `ipaddress` text NOT NULL,
  `bytes_received` text NOT NULL,
  `bytes_sent` text NOT NULL,
  `bandwidth` bigint(50) NOT NULL DEFAULT 0,
  `time` datetime NOT NULL,
  `time_in` datetime NOT NULL,
  `time_out` datetime NOT NULL,
  `status` enum('offline','online') NOT NULL,
  `timestamp` int(11) NOT NULL,
  `category` enum('premium','vip','ph','private','free') NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `blocked_ips`
--

CREATE TABLE `blocked_ips` (
  `id` int(11) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `blocked_until` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `chat`
--

CREATE TABLE `chat` (
  `id` int(11) NOT NULL,
  `chat_id1` int(11) NOT NULL,
  `chat_id2` int(11) NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_status` enum('seen','unseen') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unseen',
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `sender_type` enum('user','admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cloudflare_domains`
--

CREATE TABLE `cloudflare_domains` (
  `id` int(11) NOT NULL,
  `domain_name` varchar(255) NOT NULL,
  `zone_id` text NOT NULL,
  `global_api` text NOT NULL,
  `email` text NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cloudflare_domains`
--

INSERT INTO `cloudflare_domains` (`id`, `domain_name`, `zone_id`, `global_api`, `email`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'ruzain.com', 'kNG/Z9qqtdzL0r2Yfs6PoJeW2qe5wIy6fIeZ5ZWo5MS3louDhruDeK6Mha2sqbvBfN16w4Wswaq5sMKgv6iWssODisWekr+lu8Gcw66ToJ2Jo5jHw82qkw==', 'j7urnNi7sbfbq9eRfqjJeKSp1pa8w5Whh6umpou4z46dyZ6tipR4jazTfuizupnJgt2Uk4a8vKq6oKSizcCAq9K/dp60ud3puomIrqy6u9yGvLq+zaeqkw==', 'is27ftm5k9vJqcR2hJHFdp6DvIa+nZq2f5p07YbMuYurybCnlqamiZjGgqyoqLvDk8+gf5a5z4Gnroat', 1, '2026-03-28 13:55:29', '2026-03-28 14:11:51'),
(3, 'runutour.com', 'h7yres26teTaucGXfsy6mq6ZuJq3hoOgkqmmuoKTup6jgY+MlKhjtLDGZcW00Luehap2mIep1qepn77qzqmikdqFipydkdOqvMKb3r3MpJ2ApaTHw82qkw==', 'j7urnNi7sbfbq9eRfqjJeKSp1pa8w5Whh6umpou4z46dyZ6tipR4jazTfuizupnJgt2Uk4a8vKq6oKSizcCAq9K/dp60ud3puomIrqy6u9yGvLq+zaeqkw==', 'is27ftm5k9vJqcR2hJHFdp6DvIa+nZq2f5p07YbMuYurybCnlqamiZjGgqyoqLvDk8+gf5a5z4Gnroat', 1, '2026-03-28 14:12:18', '2026-03-28 14:12:18');

-- --------------------------------------------------------

--
-- Table structure for table `conversion_logs`
--

CREATE TABLE `conversion_logs` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `premium` varchar(755) NOT NULL,
  `vip` varchar(755) NOT NULL,
  `description` varchar(755) NOT NULL,
  `logs_date` datetime NOT NULL,
  `ipaddress` varchar(32) NOT NULL DEFAULT '0.0.0.0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `credits_logs`
--

CREATE TABLE `credits_logs` (
  `id` int(11) NOT NULL,
  `credits_id` varchar(11) COLLATE utf8_unicode_ci NOT NULL,
  `credits_id2` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `credits_type` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `credits_qty` int(11) NOT NULL,
  `credits_date` datetime NOT NULL,
  `seller` varchar(20) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `credits_logs`
--

INSERT INTO `credits_logs` (`id`, `credits_id`, `credits_id2`, `credits_type`, `credits_qty`, `credits_date`, `seller`) VALUES
(79, '1', 'akher', 'add', 50, '2026-01-01 01:15:10', ''),
(80, '1', 'ibrahim', 'add', 50, '2026-01-01 01:16:07', ''),
(81, '1', 'saiful', 'add', 100, '2026-01-08 00:00:25', ''),
(82, '1', 'jeddah', 'add', 1, '2026-01-19 13:07:06', '');

-- --------------------------------------------------------

--
-- Table structure for table `cronjob_banned_ip`
--

CREATE TABLE `cronjob_banned_ip` (
  `id` int(11) NOT NULL,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `content` varchar(128) NOT NULL DEFAULT 'Attempting',
  `ip` varchar(128) NOT NULL DEFAULT '0.0.0.0',
  `logs_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cronjob_logs`
--

CREATE TABLE `cronjob_logs` (
  `id` int(11) NOT NULL,
  `content` text NOT NULL,
  `ipaddress` varchar(128) NOT NULL DEFAULT '0.0.0.0',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_app_logs`
--

CREATE TABLE `deleted_app_logs` (
  `id` int(11) NOT NULL,
  `app_id` int(11) NOT NULL,
  `app_title` varchar(55) CHARACTER SET latin1 NOT NULL,
  `date_uploaded` datetime NOT NULL,
  `date_deleted` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_logs`
--

CREATE TABLE `deleted_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(50) NOT NULL,
  `user_upline` int(50) NOT NULL,
  `user_level` varchar(50) CHARACTER SET latin1 NOT NULL,
  `date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dns`
--

CREATE TABLE `dns` (
  `dns_id` int(255) NOT NULL,
  `record_id` varchar(50) CHARACTER SET latin1 NOT NULL,
  `host_name` varchar(255) CHARACTER SET latin1 NOT NULL,
  `domain_name` varchar(255) CHARACTER SET latin1 NOT NULL,
  `ip_address` varchar(50) CHARACTER SET latin1 NOT NULL,
  `record_type` varchar(50) CHARACTER SET latin1 NOT NULL,
  `status` int(10) NOT NULL,
  `global_api` varchar(255) CHARACTER SET latin1 NOT NULL,
  `zone_id` varchar(255) CHARACTER SET latin1 NOT NULL,
  `email` varchar(155) CHARACTER SET latin1 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `download`
--

CREATE TABLE `download` (
  `id` int(11) NOT NULL,
  `download_category` enum('public','seller') NOT NULL,
  `download_title` varchar(767) NOT NULL,
  `download_msg` text NOT NULL,
  `download_network` enum('NOTICE','UPDATE') NOT NULL,
  `download_device` enum('ANDROID','IOS','WINDOWS','CONFIG','OTHERS') NOT NULL,
  `download_file` varchar(999) NOT NULL,
  `download_date` datetime NOT NULL,
  `views` int(11) NOT NULL DEFAULT 0,
  `downloaded` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `download`
--

INSERT INTO `download` (`id`, `download_category`, `download_title`, `download_msg`, `download_network`, `download_device`, `download_file`, `download_date`, `views`, `downloaded`) VALUES
(14, 'public', 'Welcome to Vollam', 'The entire team of Vollam is thrilled to welcome you on board. We hope you&rsquo;ll do some amazing works here!&nbsp;<br /><br />Congratulations on being part of the team! The whole team welcomes you and we look forward to a successful journey with you! Welcome aboard!', 'NOTICE', 'OTHERS', '', '2020-12-13 10:01:13', 0, 0),
(15, 'public', 'How to update Vollam applications', 'Vollam applications get staged automatic updates. It means that some users get their automatic&nbsp;updates earlier than others. The reason for that is to avoid massive issues in case&nbsp;of some failure related to the updates.<br /><br />If you haven&#39;t got an automatic update yet, you will get it within a few days. If you wish to get the latest app version now, you can download it from our&nbsp;News and Updates section. The download page always provides&nbsp;the latest available app versions for all operating systems.', 'NOTICE', 'OTHERS', '', '2020-12-11 17:35:19', 0, 0),
(16, 'public', 'VPN for Netflix: watch Netflix securely', '<p>To ensure&nbsp;secure access to Netflix, you can connect to&nbsp;<strong>any of our servers&nbsp;listed below</strong>. We recommend using the servers closest to your location for the best connection speed and stability.<br /><br /><strong>Netflix US:</strong><br />You should connect to any of our servers in countries&nbsp;<strong>other than</strong>&nbsp;Canada, Germany, the United Kingdom, France, Italy, Japan, Australia, the Netherlands, India, Brazil, Spain, Portugal, South Korea, and Finland.</p><p><strong>Netflix CA:</strong><br />You should connect to any of our servers in Canada.</p><p><strong>Netflix DE:</strong><br />You should connect to any of our servers in Germany.</p>', 'NOTICE', 'OTHERS', '', '2020-12-11 17:35:46', 0, 0),
(46, 'public', 'Test Update with APK', 'Test Notice and Update with apk file attachment.', 'UPDATE', 'ANDROID', '1605592512.apk', '2020-11-17 13:55:12', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `duration`
--

CREATE TABLE `duration` (
  `id` int(11) NOT NULL,
  `duration_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `duration_time` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `duration`
--

INSERT INTO `duration` (`id`, `duration_name`, `duration_time`) VALUES
(1, '1 Hour', 3600),
(2, '2 Hours', 7200),
(3, '3 Hours', 10800),
(4, '4 Hours', 14400),
(5, '5 Hours', 18000),
(6, '6 Hours', 21600),
(7, '7 Hours', 25200),
(8, '8 Hours', 28800),
(9, '9 Hours', 32400),
(10, '10 Hours', 36000),
(11, '11 Hours', 39600),
(12, '12 Hours', 43200),
(13, '13 Hours', 46800),
(14, '14 Hours', 50400),
(15, '15 Hours', 54000),
(16, '16 Hours', 57600),
(17, '17 Hours', 61200),
(18, '18 Hours', 64800),
(19, '19 Hours', 68400),
(20, '20 Hours', 72000),
(21, '21 Hours', 75600),
(22, '22 Hours', 79200),
(23, '23 Hours', 82800),
(24, '1 Day', 86400),
(25, '2 Days', 172800),
(26, '3 Days', 259200),
(27, '4 Days', 345600),
(28, '5 Days', 432000),
(29, '6 Days', 518400),
(30, '7 Days', 604800),
(31, '8 Days', 691200),
(32, '9 Days', 777600),
(33, '10 Days', 864000),
(34, '15 Days', 1296000),
(35, '20 Days', 1728000),
(36, '30 Days', 2592000),
(37, '31 Days', 2678400),
(38, '32 Days', 2764800),
(39, '-3 Days', -259200);

-- --------------------------------------------------------

--
-- Table structure for table `duration_logs`
--

CREATE TABLE `duration_logs` (
  `id` int(11) NOT NULL,
  `duration_id` int(11) NOT NULL,
  `duration_id2` int(11) NOT NULL,
  `duration_username` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `duration_qty` int(11) NOT NULL,
  `duration_item` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `duration_date` datetime NOT NULL,
  `duration_type` enum('premium','vip','private') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'premium',
  `ipaddress` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0.0.0.0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `email_campaigns`
--

CREATE TABLE `email_campaigns` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `content_type` enum('html','text') DEFAULT 'html',
  `status` enum('draft','scheduled','sending','sent','paused') DEFAULT 'draft',
  `created_by` int(11) NOT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `updated_date` datetime DEFAULT NULL,
  `scheduled_date` datetime DEFAULT NULL,
  `sent_date` datetime DEFAULT NULL,
  `total_recipients` int(11) DEFAULT 0,
  `recipient_type` varchar(50) DEFAULT 'all',
  `emails_sent` int(11) DEFAULT 0,
  `emails_failed` int(11) DEFAULT 0,
  `opens` int(11) DEFAULT 0,
  `clicks` int(11) DEFAULT 0,
  `unsubscribes` int(11) DEFAULT 0,
  `bounces` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `email_campaign_recipients`
--

CREATE TABLE `email_campaign_recipients` (
  `id` int(11) NOT NULL,
  `campaign_id` int(11) NOT NULL,
  `subscriber_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `status` enum('pending','sent','failed','opened','clicked','unsubscribed','bounced') DEFAULT 'pending',
  `sent_date` datetime DEFAULT NULL,
  `opened_date` datetime DEFAULT NULL,
  `clicked_date` datetime DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `tracking_token` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `email_subscribers`
--

CREATE TABLE `email_subscribers` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `status` enum('active','unsubscribed','bounced') DEFAULT 'active',
  `source` varchar(50) DEFAULT 'manual',
  `tags` text DEFAULT NULL,
  `subscribed_date` datetime DEFAULT current_timestamp(),
  `unsubscribed_date` datetime DEFAULT NULL,
  `last_email_sent` datetime DEFAULT NULL,
  `email_count` int(11) DEFAULT 0,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `email_subscribers`
--

INSERT INTO `email_subscribers` (`id`, `email`, `name`, `status`, `source`, `tags`, `subscribed_date`, `unsubscribed_date`, `last_email_sent`, `email_count`, `ip_address`, `user_agent`) VALUES
(2, 'azimaxus@gmail.com', 'Admin', 'active', 'manual', 'vpn', '2025-11-12 14:52:27', NULL, '2025-12-08 00:23:52', 21, '::1', NULL),
(4, 'datasoftcaresales@gmail.com', 'Anoarul', 'active', 'manual', 'vpn', '2025-11-12 21:14:26', NULL, '2025-12-08 00:23:55', 21, '::1', NULL),
(5, 'proscoviadaker@gmail.com', 'Odong Godfrey', 'active', 'reseller_application', 'reseller,vpn', '2026-01-11 08:00:37', NULL, NULL, 0, '51.195.203.184', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36'),
(6, 'ghadeeralemaarcse@gmail.com', 'Anoarul Azimxxx', 'active', 'reseller_application', 'reseller,vpn', '2025-11-14 17:37:37', NULL, NULL, 0, '::1', NULL),
(7, 'ghadeeralemaarce@gmail.com', 'Anoarul Azim', 'active', 'reseller_application', 'reseller,vpn', '2025-11-14 17:38:34', NULL, NULL, 0, '::1', NULL),
(8, 'alamindevelop@gmail.com', 'ALAMIN MIA', 'active', 'reseller_application', 'reseller,vpn', '2026-01-29 03:38:04', NULL, NULL, 0, '2404:1c40:481:bae0:188f:255d:a3af:3d90', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36');

-- --------------------------------------------------------

--
-- Table structure for table `email_templates`
--

CREATE TABLE `email_templates` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `content_type` enum('html','text') DEFAULT 'html',
  `template_type` enum('newsletter','promotion','announcement','welcome','custom') DEFAULT 'custom',
  `created_by` int(11) NOT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `updated_date` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `email_templates`
--

INSERT INTO `email_templates` (`id`, `name`, `subject`, `content`, `content_type`, `template_type`, `created_by`, `created_date`, `updated_date`, `is_active`) VALUES
(1, 'Welcome Newsletter', 'Welcome to Our VPN Service!', '<h2>Welcome to Our VPN Service!</h2>\n<p>Hello {name},</p>\n<p>Thank you for your interest in our VPN service. We are excited to have you join our community!</p>\n<p>Here is what you can expect:</p>\n<ul>\n<li>Fast and secure VPN connections</li>\n<li>Multiple server locations worldwide</li>\n<li>24/7 customer support</li>\n<li>Easy-to-use applications</li>\n</ul>\n<p><a href=\"{website_url}\">Visit Our Website</a></p>\n<p>You received this email because you subscribed to our newsletter.</p>\n<p><a href=\"{unsubscribe_url}\">Unsubscribe</a></p>', 'html', 'welcome', 1, '2025-11-12 14:37:43', '2025-11-12 14:37:43', 1),
(2, 'Admin', 'xxxxx', 'xxxxxxx', 'html', 'promotion', 1, '2025-11-12 15:27:52', '2025-11-12 15:27:52', 1),
(4, 'Welcome Newsletter (Copy 2)', 'Welcome to Our VPN Service!', '<h2>Welcome to Our VPN Service!</h2>\n<p>Hello {name},</p>\n<p>Thank you for your interest in our VPN service. We are excited to have you join our community!</p>\n<p>Here is what you can expect:</p>\n<ul>\n<li>Fast and secure VPN connections</li>\n<li>Multiple server locations worldwide</li>\n<li>24/7 customer support</li>\n<li>Easy-to-use applications</li>\n</ul>\n<p><a href=\"{website_url}\">Visit Our Website</a></p>\n<p>You received this email because you subscribed to our newsletter.</p>\n<p><a href=\"{unsubscribe_url}\">Unsubscribe</a></p>', 'html', 'welcome', 1, '2025-11-12 15:33:30', '2025-11-12 15:33:30', 1),
(14, 'Modern Welcome Email', 'Welcome to {website_name} - Your VPN Journey Starts Here!', '<meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <style>\n        body { margin: 0; padding: 0; font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }\n        .container { max-width: 600px; margin: 0 auto; background: white; }\n        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 20px; text-align: center; }\n        .header h1 { color: white; margin: 0; font-size: 28px; }\n        .content { padding: 40px 30px; }\n        .welcome-box { background: #f8f9ff; border-left: 4px solid #667eea; padding: 20px; margin: 20px 0; }\n        .btn { display: inline-block; background: #667eea; color: white; padding: 15px 30px; text-decoration: none; border-radius: 25px; margin: 20px 0; }\n        .features { display: flex; flex-wrap: wrap; gap: 20px; margin: 30px 0; }\n        .feature { flex: 1; min-width: 150px; text-align: center; padding: 20px; background: #f8f9ff; border-radius: 10px; }\n        .footer { background: #333; color: white; padding: 30px; text-align: center; }\n    </style>\n\n\n    <div class=\"container\">\n        <div class=\"header\">\n            <h1>???? Welcome Aboard!</h1>\n        </div>\n        <div class=\"content\">\n            <div class=\"welcome-box\">\n                <h2>Hello {name}!</h2>\n                <p>Welcome to our premium VPN service! We are excited to have you join our community of privacy-conscious users.</p>\n            </div>\n            \n            <div class=\"features\">\n                <div class=\"feature\">\n                    <h3>???? Secure</h3>\n                    <p>Military-grade encryption</p>\n                </div>\n                <div class=\"feature\">\n                    <h3>⚡ Fast</h3>\n                    <p>Lightning-fast servers</p>\n                </div>\n                <div class=\"feature\">\n                    <h3>???? Global</h3>\n                    <p>Servers worldwide</p>\n                </div>\n            </div>\n            \n            <p>Your account is now active and ready to use. Click the button below to get started:</p>\n            <a href=\"{website_url}\" class=\"btn\">Get Started Now</a>\n            \n            <p>If you have any questions, our 24/7 support team is here to help!</p>\n        </div>\n        <div class=\"footer\">\n            <p>© 2024 VPN Service. All rights reserved.</p>\n            <p><a href=\"{unsubscribe_url}\" style=\"color: #ccc;\">Unsubscribe</a></p>\n        </div>\n    </div>', 'html', 'welcome', 1, '2025-11-12 16:52:53', '2025-11-12 17:20:31', 1),
(23, 'Newsletter - Tech Updates', '???? Weekly Tech Updates & VPN News', '<meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <style>\n        body { margin: 0; padding: 0; font-family: \"Segoe UI\", Arial, sans-serif; background: #f4f4f4; }\n        .container { max-width: 600px; margin: 0 auto; background: white; box-shadow: 0 0 20px rgba(0,0,0,0.1); }\n        .header { background: #2c3e50; color: white; padding: 30px; text-align: center; }\n        .content { padding: 30px; }\n        .article { border-bottom: 1px solid #eee; padding: 20px 0; }\n        .article:last-child { border-bottom: none; }\n        .article h3 { color: #2c3e50; margin-top: 0; }\n        .read-more { color: #3498db; text-decoration: none; font-weight: bold; }\n        .stats { background: #ecf0f1; padding: 20px; border-radius: 10px; margin: 20px 0; }\n        .footer { background: #34495e; color: white; padding: 20px; text-align: center; }\n    </style>\n\n\n    <div class=\"container\">\n        <div class=\"header\">\n            <h1>???? Weekly Newsletter</h1>\n            <p>Stay updated with the latest in VPN technology</p>\n        </div>\n        <div class=\"content\">\n            <p>Hi {name},</p>\n            \n            <div class=\"stats\">\n                <h3>???? This Week in Numbers</h3>\n                <p>• 50,000+ new users joined<br>\n                • 99.9% uptime maintained<br>\n                • 15 new server locations added</p>\n            </div>\n            \n            <div class=\"article\">\n                <h3>???? New Security Features Released</h3>\n                <p>We have enhanced our encryption protocols with the latest WireGuard technology, providing even faster and more secure connections.</p>\n                <a href=\"{website_url}\" class=\"read-more\">Read More →</a>\n            </div>\n            \n            <div class=\"article\">\n                <h3>???? Server Expansion Update</h3>\n                <p>New servers are now live in Tokyo, Sydney, and São Paulo, bringing our total to over 100 locations worldwide.</p>\n                <a href=\"{website_url}\" class=\"read-more\">View All Locations →</a>\n            </div>\n            \n            <div class=\"article\">\n                <h3>???? Privacy Tip of the Week</h3>\n                <p>Always use HTTPS websites when browsing. Look for the lock icon in your browser address bar to ensure your connection is encrypted.</p>\n            </div>\n        </div>\n        <div class=\"footer\">\n            <p>Thank you for being part of our community!</p>\n            <p><a href=\"{unsubscribe_url}\" style=\"color: #bdc3c7;\">Unsubscribe</a> | <a href=\"{website_url}\" style=\"color: #bdc3c7;\">Visit Website</a></p>\n        </div>\n    </div>', 'html', 'newsletter', 1, '2025-11-12 17:24:46', '2025-11-12 17:24:46', 1),
(24, 'c', '???? Limited Time: 50% OFF Premium VPN Plans!', '<meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <style>\n        body { margin: 0; padding: 0; font-family: Arial, sans-serif; background: linear-gradient(45deg, #ff6b6b, #feca57); }\n        .container { max-width: 600px; margin: 0 auto; background: white; }\n        .header { background: linear-gradient(45deg, #ff6b6b, #feca57); padding: 40px 20px; text-align: center; color: white; }\n        .offer-badge { background: #ff4757; color: white; padding: 10px 20px; border-radius: 50px; display: inline-block; font-weight: bold; margin: 10px 0; }\n        .content { padding: 40px 30px; text-align: center; }\n        .price-box { background: #f1f2f6; padding: 30px; border-radius: 15px; margin: 30px 0; }\n        .old-price { text-decoration: line-through; color: #999; font-size: 18px; }\n        .new-price { color: #ff4757; font-size: 36px; font-weight: bold; }\n        .cta-button { background: linear-gradient(45deg, #ff6b6b, #feca57); color: white; padding: 20px 40px; text-decoration: none; border-radius: 50px; font-size: 18px; font-weight: bold; display: inline-block; margin: 20px 0; }\n        .countdown { background: #2f3542; color: white; padding: 20px; border-radius: 10px; margin: 20px 0; }\n        .footer { background: #2f3542; color: white; padding: 20px; text-align: center; }\n    </style>\n\n\n    <div class=\"container\">\n        <div class=\"header\">\n            <div class=\"offer-badge\">LIMITED TIME OFFER</div>\n            <h1>???? MEGA SALE</h1>\n            <h2>50% OFF Everything!</h2>\n        </div>\n        <div class=\"content\">\n            <p>Hi {name},</p>\n            <p>This is your chance to get premium VPN protection at an unbeatable price!</p>\n            \n            <div class=\"price-box\">\n                <h3>Premium Annual Plan</h3>\n                <div class=\"old-price\">$99.99/year</div>\n                <div class=\"new-price\">$49.99/year</div>\n                <p><strong>Save $50 instantly!</strong></p>\n            </div>\n            \n            <div class=\"countdown\">\n                <h3>⏰ Hurry! Offer expires in:</h3>\n                <p style=\"font-size: 24px; margin: 0;\"><strong>48 HOURS</strong></p>\n            </div>\n            \n            <a href=\"{website_url}\" class=\"cta-button\">Claim Your 50% Discount</a>\n            \n            <p><strong>What you get:</strong></p>\n            <p>✅ Unlimited bandwidth<br>\n            ✅ 100+ server locations<br>\n            ✅ 24/7 customer support<br>\n            ✅ 30-day money-back guarantee</p>\n            \n            <p><em>No coupon code needed - discount applied automatically!</em></p>\n        </div>\n        <div class=\"footer\">\n            <p>This offer is exclusive to our subscribers</p>\n            <p><a href=\"{unsubscribe_url}\" style=\"color: #a4b0be;\">Unsubscribe</a></p>\n        </div>\n    </div>', 'html', 'promotion', 1, '2025-11-12 17:46:27', '2025-11-12 17:46:27', 1),
(25, 'Welcome Email', 'Welcome to {website_name}!', '<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><style>body{font-family:Arial,sans-serif;margin:0;padding:20px;background:#f4f4f4}.container{max-width:600px;margin:0 auto;background:white;padding:30px;border-radius:8px}</style></head><body><div class=\"container\"><h1>Welcome {name}!</h1><p>Thank you for joining us. We are excited to have you aboard!</p><p>Best regards,<br>The Team</p></div></body></html>', 'html', 'welcome', 0, '2025-11-12 21:21:50', '2025-11-12 21:21:50', 1),
(26, 'Newsletter Template', 'Monthly Newsletter - {website_name}', '<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><style>body{font-family:Arial,sans-serif;margin:0;padding:20px;background:#f4f4f4}.container{max-width:600px;margin:0 auto;background:white;padding:30px;border-radius:8px}.header{background:#007bff;color:white;padding:20px;text-align:center;border-radius:8px 8px 0 0}</style></head><body><div class=\"container\"><div class=\"header\"><h1>📰 Monthly Newsletter</h1></div><div style=\"padding:20px\"><p>Hello {name},</p><p>Here are the latest updates from our team...</p><p>Best regards,<br>The Newsletter Team</p></div></div></body></html>', 'html', 'newsletter', 0, '2025-11-12 21:21:50', '2025-11-12 21:21:50', 1),
(27, 'Promotion Email', 'Special Offer Just for You!', '<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><style>body{font-family:Arial,sans-serif;margin:0;padding:20px;background:#f4f4f4}.container{max-width:600px;margin:0 auto;background:white;padding:30px;border-radius:8px}.promo{background:#28a745;color:white;padding:20px;text-align:center;border-radius:8px;margin:20px 0}</style></head><body><div class=\"container\"><h1>🎉 Special Offer!</h1><div class=\"promo\"><h2>50% OFF</h2><p>Limited time offer for {name}</p></div><p>Don\'t miss out on this amazing deal!</p><p>Best regards,<br>The Sales Team</p></div></body></html>', 'html', 'promotion', 0, '2025-11-12 21:21:50', '2025-11-12 21:21:50', 1),
(28, 'Welcome Email', 'Welcome to {website_name}!', '<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><style>body{font-family:Arial,sans-serif;margin:0;padding:20px;background:#f4f4f4}.container{max-width:600px;margin:0 auto;background:white;padding:30px;border-radius:8px}</style></head><body><div class=\"container\"><h1>Welcome {name}!</h1><p>Thank you for joining us. We are excited to have you aboard!</p><p>Best regards,<br>The Team</p></div></body></html>', 'html', 'welcome', 0, '2025-11-12 22:01:16', '2025-11-12 22:01:16', 1),
(29, 'Newsletter Template', 'Monthly Newsletter - {website_name}', '<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><style>body{font-family:Arial,sans-serif;margin:0;padding:20px;background:#f4f4f4}.container{max-width:600px;margin:0 auto;background:white;padding:30px;border-radius:8px}.header{background:#007bff;color:white;padding:20px;text-align:center;border-radius:8px 8px 0 0}</style></head><body><div class=\"container\"><div class=\"header\"><h1>📰 Monthly Newsletter</h1></div><div style=\"padding:20px\"><p>Hello {name},</p><p>Here are the latest updates from our team...</p><p>Best regards,<br>The Newsletter Team</p></div></div></body></html>', 'html', 'newsletter', 0, '2025-11-12 22:01:16', '2025-11-12 22:01:16', 1),
(30, 'Promotion Email', 'Special Offer Just for You!', '<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><style>body{font-family:Arial,sans-serif;margin:0;padding:20px;background:#f4f4f4}.container{max-width:600px;margin:0 auto;background:white;padding:30px;border-radius:8px}.promo{background:#28a745;color:white;padding:20px;text-align:center;border-radius:8px;margin:20px 0}</style></head><body><div class=\"container\"><h1>🎉 Special Offer!</h1><div class=\"promo\"><h2>50% OFF</h2><p>Limited time offer for {name}</p></div><p>Don\'t miss out on this amazing deal!</p><p>Best regards,<br>The Sales Team</p></div></body></html>', 'html', 'promotion', 0, '2025-11-12 22:01:16', '2025-11-12 22:01:16', 1);

-- --------------------------------------------------------

--
-- Table structure for table `freeze_request`
--

CREATE TABLE `freeze_request` (
  `id` int(11) NOT NULL,
  `content` varchar(128) NOT NULL DEFAULT 'Freeze Request',
  `status` enum('pending','approved') NOT NULL DEFAULT 'pending',
  `client_id` int(11) NOT NULL,
  `client_name` varchar(128) NOT NULL,
  `client_ipaddress` varchar(128) NOT NULL DEFAULT '0.0.0.0',
  `request_date` datetime NOT NULL DEFAULT current_timestamp(),
  `reseller_id` int(11) NOT NULL,
  `reseller_name` varchar(128) NOT NULL,
  `reseller_ipaddress` varchar(128) NOT NULL DEFAULT '0.0.0.0',
  `process_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `json_update`
--

CREATE TABLE `json_update` (
  `id` int(11) NOT NULL,
  `name` varchar(20) CHARACTER SET latin1 NOT NULL,
  `type` int(10) NOT NULL,
  `encryption` varchar(50) CHARACTER SET latin1 NOT NULL,
  `date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `json_update`
--

INSERT INTO `json_update` (`id`, `name`, `type`, `encryption`, `date`) VALUES
(2, 'new app', 1, 'c3b941eacfb8ba9c8870', '2026-03-28 07:06:24');

-- --------------------------------------------------------

--
-- Table structure for table `limit_logs`
--

CREATE TABLE `limit_logs` (
  `id` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `username` varchar(64) COLLATE latin1_general_ci NOT NULL,
  `subadmin_limit` int(11) NOT NULL DEFAULT 0,
  `reseller_limit` int(11) NOT NULL DEFAULT 0,
  `subreseller_limit` int(11) NOT NULL DEFAULT 0,
  `client_limit` int(11) NOT NULL,
  `user_level` enum('normal','reseller','subreseller','subadmin','admin','superadmin') COLLATE latin1_general_ci NOT NULL DEFAULT 'normal',
  `logs_date` datetime NOT NULL,
  `ipaddress` varchar(64) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `limit_registration`
--

CREATE TABLE `limit_registration` (
  `id` int(11) NOT NULL,
  `ipaddress` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `regtime` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

CREATE TABLE `login_attempts` (
  `ip` varchar(20) DEFAULT NULL,
  `attempts` int(11) DEFAULT 0,
  `lastlogin` datetime DEFAULT NULL,
  `timestamp` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts_logs`
--

CREATE TABLE `login_attempts_logs` (
  `id` int(11) NOT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `user_name` varchar(64) NOT NULL,
  `logs_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `login_banned_ip`
--

CREATE TABLE `login_banned_ip` (
  `id` int(11) NOT NULL,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `ip` varchar(128) NOT NULL DEFAULT '0.0.0.0',
  `logs_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `nas`
--

CREATE TABLE `nas` (
  `id` int(10) NOT NULL,
  `nasname` varchar(128) NOT NULL,
  `shortname` varchar(32) DEFAULT NULL,
  `type` varchar(30) DEFAULT 'other',
  `ports` int(5) DEFAULT NULL,
  `secret` varchar(60) NOT NULL DEFAULT 'secret',
  `server` varchar(64) DEFAULT NULL,
  `community` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT 'RADIUS Client'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` int(11) NOT NULL,
  `title` varchar(50) CHARACTER SET latin1 NOT NULL,
  `filename` varchar(50) CHARACTER SET latin1 NOT NULL,
  `type` int(10) NOT NULL,
  `date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `page_content`
--

CREATE TABLE `page_content` (
  `id` int(11) NOT NULL,
  `page_name` varchar(100) NOT NULL,
  `section_name` varchar(100) NOT NULL,
  `section_content` text NOT NULL,
  `section_type` enum('text','textarea','html') DEFAULT 'text',
  `is_active` tinyint(1) DEFAULT 1,
  `section_order` int(11) DEFAULT 1,
  `created_date` datetime DEFAULT current_timestamp(),
  `updated_date` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `page_content`
--

INSERT INTO `page_content` (`id`, `page_name`, `section_name`, `section_content`, `section_type`, `is_active`, `section_order`, `created_date`, `updated_date`) VALUES
(1, 'site-info', 'hero_title', 'Saudi Arabia SIM Companie', 'text', 1, 1, '2025-11-13 15:38:58', '2025-11-13 15:38:58'),
(2, 'site-info', 'main_description', '<font color=\"#ff0000\">Choose from premium telecom services offering high-speed internet, unlimited calls, and exclusive packages. Compare</font> <span style=\"color: #28a745; font-weight: bold;\">FREE plans</span> and <span style=\"color: #007bff; font-weight: bold;\">PREMIUM packages</span> <font color=\"#9c00ff\">from leading operators across the Kingdom.</font>', 'text', 1, 1, '2025-11-13 15:38:58', '2025-11-13 16:25:06'),
(3, 'site-info', 'stc_package_type', 'FREE', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:40'),
(4, 'site-info', 'stc_package_title', 'Stc Plan', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(5, 'site-info', 'stc_package_description', 'Package description', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(6, 'site-info', 'stc_package_features', 'Package features', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(7, 'site-info', 'mobily_package_type', 'FREE', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(8, 'site-info', 'mobily_package_title', 'Mobily Plan', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(9, 'site-info', 'mobily_package_description', 'Package description', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(10, 'site-info', 'mobily_package_features', 'Package features', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(11, 'site-info', 'zain_package_type', 'FREE', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(12, 'site-info', 'zain_package_title', 'Zain Plan', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(13, 'site-info', 'zain_package_description', 'Package description', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(14, 'site-info', 'zain_package_features', 'Package features', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(15, 'site-info', 'virgin_package_type', 'FREE', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(16, 'site-info', 'virgin_package_title', 'Virgin Plan', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(17, 'site-info', 'virgin_package_description', 'Package description', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(18, 'site-info', 'virgin_package_features', 'Package features', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(19, 'site-info', 'lebara_package_type', 'FREE', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(20, 'site-info', 'lebara_package_title', 'Lebara Plan', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(21, 'site-info', 'lebara_package_description', 'Package description', 'text', 1, 1, '2025-11-13 16:30:49', '2025-11-13 16:57:41'),
(22, 'site-info', 'lebara_package_features', 'Package features', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:41'),
(23, 'site-info', 'friendi_package_type', 'FREE', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:41'),
(24, 'site-info', 'friendi_package_title', 'Friendi Plan', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:41'),
(25, 'site-info', 'friendi_package_description', 'Package description', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:41'),
(26, 'site-info', 'friendi_package_features', 'Package features', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:41'),
(27, 'site-info', 'redbull_package_type', 'FREE', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:41'),
(28, 'site-info', 'redbull_package_title', 'Redbull Plan', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(29, 'site-info', 'redbull_package_description', 'Package description', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(30, 'site-info', 'redbull_package_features', 'Package features', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(31, 'site-info', 'salam_package_type', 'FREE', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(32, 'site-info', 'salam_package_title', 'Salam Plan', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(33, 'site-info', 'salam_package_description', 'Package description', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(34, 'site-info', 'salam_package_features', 'Package features', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(35, 'site-info', 'jawwy_package_type', 'FREE', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(36, 'site-info', 'jawwy_package_title', 'Jawwy Plan', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(37, 'site-info', 'jawwy_package_description', 'Package description', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(38, 'site-info', 'jawwy_package_features', 'Package features', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(39, 'site-info', 'yaqoot_package_type', 'FREE', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(40, 'site-info', 'yaqoot_package_title', 'Yaqoot Plan', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(41, 'site-info', 'yaqoot_package_description', 'Package description', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42'),
(42, 'site-info', 'yaqoot_package_features', 'Package features', 'text', 1, 1, '2025-11-13 16:30:50', '2025-11-13 16:57:42');

-- --------------------------------------------------------

--
-- Table structure for table `page_customizations`
--

CREATE TABLE `page_customizations` (
  `id` int(11) NOT NULL,
  `page_name` varchar(100) NOT NULL,
  `customization_type` varchar(50) NOT NULL,
  `customization_data` text NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `updated_date` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `page_customizations`
--

INSERT INTO `page_customizations` (`id`, `page_name`, `customization_type`, `customization_data`, `user_id`, `created_date`, `updated_date`) VALUES
(1, 'site-info', 'design', '{\"colorScheme\":\"blue\",\"fontFamily\":\"nunito, \\\"segoe ui\\\", arial\",\"fontSize\":\"14\",\"cardOpacity\":\"1\",\"animationSpeed\":\"3\"}', 1, '2025-11-13 15:39:22', '2025-11-13 17:52:43'),
(2, 'site-info', 'layout', '{\"layoutType\":\"grid\",\"cardSpacing\":\"20\",\"containerWidth\":\"100\"}', 1, '2025-11-13 15:40:43', '2025-11-13 17:52:43');

-- --------------------------------------------------------

--
-- Table structure for table `radacct`
--

CREATE TABLE `radacct` (
  `radacctid` bigint(21) NOT NULL,
  `acctsessionid` varchar(64) NOT NULL DEFAULT '',
  `acctuniqueid` varchar(32) NOT NULL DEFAULT '',
  `username` varchar(64) NOT NULL DEFAULT '',
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `realm` varchar(64) DEFAULT '',
  `nasipaddress` varchar(15) NOT NULL DEFAULT '',
  `nasportid` varchar(15) DEFAULT NULL,
  `nasporttype` varchar(32) DEFAULT NULL,
  `acctstarttime` datetime DEFAULT NULL,
  `acctstoptime` datetime DEFAULT NULL,
  `acctsessiontime` int(12) UNSIGNED DEFAULT NULL,
  `acctauthentic` varchar(32) DEFAULT NULL,
  `connectinfo_start` varchar(50) DEFAULT NULL,
  `connectinfo_stop` varchar(50) DEFAULT NULL,
  `acctinputoctets` bigint(20) DEFAULT NULL,
  `acctoutputoctets` bigint(20) DEFAULT NULL,
  `calledstationid` varchar(50) NOT NULL DEFAULT '',
  `callingstationid` varchar(50) NOT NULL DEFAULT '',
  `acctterminatecause` varchar(32) NOT NULL DEFAULT '',
  `servicetype` varchar(32) DEFAULT NULL,
  `framedprotocol` varchar(32) DEFAULT NULL,
  `framedipaddress` varchar(15) NOT NULL DEFAULT '',
  `acctstartdelay` int(12) UNSIGNED DEFAULT NULL,
  `acctstopdelay` int(12) UNSIGNED DEFAULT NULL,
  `xascendsessionsvrkey` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `radcheck`
--

CREATE TABLE `radcheck` (
  `id` int(11) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '==',
  `value` varchar(253) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `radcheck`
--

INSERT INTO `radcheck` (`id`, `username`, `attribute`, `op`, `value`) VALUES
(1, 'dev11', 'Cleartext-Password', ':=', 'dev11'),
(2, 'dev22', 'Cleartext-Password', ':=', 'dev22'),
(3, 'dev33', 'Cleartext-Password', ':=', 'dev33'),
(4, 'apptest', 'Cleartext-Password', ':=', 'test1234'),
(5, '51357', 'Cleartext-Password', ':=', '68068'),
(6, '52444', 'Cleartext-Password', ':=', '49892'),
(7, '11780', 'Cleartext-Password', ':=', '13790'),
(8, 'dev55', 'Cleartext-Password', ':=', 'dev55'),
(9, 'dev44', 'Cleartext-Password', ':=', 'dev44'),
(10, 'udpuser', 'Cleartext-Password', ':=', 'udpuser'),
(11, 'testuser123', 'Cleartext-Password', ':=', 'testpass123'),
(24, 'user147116', 'Cleartext-Password', ':=', 'W1d44t5b'),
(13, 'testuser123a', 'Cleartext-Password', ':=', 'testpass123a'),
(25, 'user454462', 'Cleartext-Password', ':=', 'wCKH3Xd0'),
(15, 'testuser123axa', 'Cleartext-Password', ':=', 'testpass123'),
(16, 'user911124', 'Cleartext-Password', ':=', '29TSo7H9'),
(26, 'user613499', 'Cleartext-Password', ':=', 'Z2siKIrY'),
(27, 'testuser1766600863', 'Cleartext-Password', ':=', 'pass123'),
(19, 'user938432', 'Cleartext-Password', ':=', 'kIOJyWst'),
(20, 'user940817', 'Cleartext-Password', ':=', 'RO1TEvJJ'),
(21, 'user768404', 'Cleartext-Password', ':=', 'nW8pUlrv'),
(28, 'user897439', 'Cleartext-Password', ':=', 'iauxn5IF'),
(29, 'testuser1766600915', 'Cleartext-Password', ':=', 'pass123'),
(30, 'azimaxu', 'Cleartext-Password', ':=', 'azimaxu'),
(31, '21079', 'Cleartext-Password', ':=', '14594'),
(32, 'dev99', 'Cleartext-Password', ':=', 'dev99'),
(33, '5fjs51', 'Cleartext-Password', ':=', '170984'),
(34, '3xaz31', 'Cleartext-Password', ':=', '47908'),
(35, '30524', 'Cleartext-Password', ':=', '97385'),
(54, '42655', 'Cleartext-Password', ':=', '31634'),
(37, 'azimgvgv', 'Cleartext-Password', ':=', '11223344'),
(50, '55921', 'Cleartext-Password', ':=', '73800'),
(42, '39038', 'Cleartext-Password', ':=', '29144'),
(48, '98284', 'Cleartext-Password', ':=', '76696'),
(55, 'dev00', 'Cleartext-Password', ':=', 'dev00'),
(51, '13366', 'Cleartext-Password', ':=', '57063'),
(53, 'masud2', 'Cleartext-Password', ':=', 'masud2'),
(56, 'dev88', 'Cleartext-Password', ':=', 'dev88'),
(57, '90749', 'Cleartext-Password', ':=', '79508'),
(58, '53146', 'Cleartext-Password', ':=', '88397'),
(60, '56415', 'Cleartext-Password', ':=', '20243'),
(68, '41132', 'Cleartext-Password', ':=', '98049'),
(67, 'saiful22', 'Cleartext-Password', ':=', 'saiful22'),
(64, '43964', 'Cleartext-Password', ':=', '77403'),
(69, '30310', 'Cleartext-Password', ':=', '75444'),
(70, '32610', 'Cleartext-Password', ':=', '57685'),
(71, '73224', 'Cleartext-Password', ':=', '29151'),
(72, '21549', 'Cleartext-Password', ':=', '73248'),
(73, '16390', 'Cleartext-Password', ':=', '97066');

-- --------------------------------------------------------

--
-- Table structure for table `radgroupcheck`
--

CREATE TABLE `radgroupcheck` (
  `id` int(11) UNSIGNED NOT NULL,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '==',
  `value` varchar(253) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `radgroupreply`
--

CREATE TABLE `radgroupreply` (
  `id` int(11) UNSIGNED NOT NULL,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '=',
  `value` varchar(253) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `radpostauth`
--

CREATE TABLE `radpostauth` (
  `id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `pass` varchar(64) NOT NULL DEFAULT '',
  `reply` varchar(32) NOT NULL DEFAULT '',
  `authdate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `radreply`
--

CREATE TABLE `radreply` (
  `id` int(11) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '=',
  `value` varchar(253) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `radusergroup`
--

CREATE TABLE `radusergroup` (
  `username` varchar(64) NOT NULL DEFAULT '',
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `priority` int(11) NOT NULL DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `recovery_logs`
--

CREATE TABLE `recovery_logs` (
  `id` int(11) NOT NULL,
  `recovery_menu` varchar(255) NOT NULL,
  `recovery_ipaddress` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `recovery_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `reloadduration_logs`
--

CREATE TABLE `reloadduration_logs` (
  `id` int(11) NOT NULL,
  `duration_id` int(11) NOT NULL,
  `duration_id2` int(11) NOT NULL,
  `duration_username` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `duration_item` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `duration_date` datetime NOT NULL,
  `duration_type` enum('premium','vip','private') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'premium',
  `ipaddress` varchar(32) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reseller_applications`
--

CREATE TABLE `reseller_applications` (
  `id` int(11) NOT NULL,
  `business_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `country` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `website` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `experience` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `expected_sales` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `message` text COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('pending','approved','rejected','under_review') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'pending',
  `admin_notes` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `applied_date` datetime NOT NULL DEFAULT current_timestamp(),
  `reviewed_date` datetime DEFAULT NULL,
  `reviewed_by` int(11) DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `user_agent` text COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `reseller_applications`
--

INSERT INTO `reseller_applications` (`id`, `business_name`, `full_name`, `email`, `username`, `password`, `phone`, `country`, `website`, `experience`, `expected_sales`, `message`, `status`, `admin_notes`, `applied_date`, `reviewed_date`, `reviewed_by`, `ip_address`, `user_agent`) VALUES
(5, 'azimxxx', 'Anoarul Azimxxx', 'ghadeeralemaarcse@gmail.com', 'azimkawsar', '$2y$10$qcwnzlvOiCHDinO8tJO5Qua8Rm0fvFF0WDm6ehSrd21e6uZTz99mO', '0598126772', 'SA', 'https://mancaberone.com', 'intermediate', '51-100', 'cccccccccccc', 'approved', 'Approved and reseller account created (Username: azimkawsar)', '2025-11-14 17:37:37', '2025-11-14 17:38:59', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(6, 'azim', 'Anoarul Azim', 'ghadeeralemaarce@gmail.com', 'reseller4', '$2y$10$Dprkvn1KWEpZs40TzcPL.OwFXhFJfMPKP9gdbn7/nAvMLKx0EgpS.', '0598126771', 'SA', 'Voillom.com', 'intermediate', '51-100', 'xxxx', 'approved', 'Approved and reseller account created (Username: reseller4)', '2025-11-14 17:38:34', '2025-11-14 17:40:11', 1, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(7, 'Bwobomanam', 'Odong Godfrey', 'proscoviadaker@gmail.com', 'Gody', 'VjBzT3hHNGlrUk5waTZVY0lnYlVKdz09', '+256784859705', 'Other', '', 'beginner', '1-50', 'It\'s worth doing', 'pending', NULL, '2026-01-11 16:00:36', NULL, NULL, '51.195.203.184', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36'),
(8, 'DX PLUS', 'ALAMIN MIA', 'alamindevelop@gmail.com', 'admin5858', 'OGxLNU5UaEZzMmo1dVRNYnR6YldsUT09', '01790026703', 'DE', 'xxx.com', 'expert', '1-50', 'Hi', 'pending', NULL, '2026-01-29 11:38:04', NULL, NULL, '2404:1c40:481:bae0:188f:255d:a3af:3d90', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36');

-- --------------------------------------------------------

--
-- Table structure for table `reseller_settings`
--

CREATE TABLE `reseller_settings` (
  `id` int(11) NOT NULL,
  `setting_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `setting_value` text COLLATE utf8_unicode_ci NOT NULL,
  `updated_date` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `reseller_settings`
--

INSERT INTO `reseller_settings` (`id`, `setting_name`, `setting_value`, `updated_date`) VALUES
(1, 'email_notifications', '1', '2025-11-14 14:02:28'),
(2, 'auto_approval', '0', '2025-11-14 14:02:28'),
(3, 'admin_email', 'vollamltd@gmail.com', '2025-11-14 17:36:06'),
(4, 'welcome_email_subject', 'Welcome to Our Reseller Program', '2025-11-14 14:02:28'),
(5, 'welcome_email_body', '<p>Dear {name},</p><p>Welcome to our reseller program! Your application has been approved.</p><p><strong>Your reseller account details:</strong><br>Username: {username}<br>Password: {password}<br>Reseller Panel: {reseller_url}</p><p style=\"font-family: &quot;Hind Siliguri&quot;, Arial, sans-serif; line-height: 1.7;\" class=\"bangla-text\">আপনাকে স্বাগতম! আপনার রিসেলার আবেদন অনুমোদিত হয়েছে।</p><p>Best regards,<br>The Team</p>', '2025-11-14 14:02:29'),
(6, 'approval_email_subject', 'Reseller Application Approved', '2025-11-14 14:02:29'),
(7, 'approval_email_body', '<p>Dear {name},</p><p>Congratulations! Your reseller application for <strong>{business_name}</strong> has been approved.</p><p style=\"font-family: &quot;Hind Siliguri&quot;, Arial, sans-serif; line-height: 1.7;\" class=\"bangla-text\">অভিনন্দন! আপনার রিসেলার আবেদন অনুমোদিত হয়েছে।</p><p>We will contact you shortly with your account details.</p><p>Best regards,<br>The Team</p>', '2025-11-14 14:02:29'),
(8, 'rejection_email_subject', 'Reseller Application Update', '2025-11-14 14:02:29'),
(9, 'rejection_email_body', '<p>Dear {name},</p><p>Thank you for your interest in our reseller program.</p><p>After careful review, we are unable to approve your application at this time.</p><p><strong>Reason:</strong> {reason}</p><p style=\"font-family: &quot;Hind Siliguri&quot;, Arial, sans-serif; line-height: 1.7;\" class=\"bangla-text\">দুঃখিত, আপনার আবেদন এই মুহূর্তে অনুমোদন করা সম্ভব হয়নি।</p><p>You may reapply in the future.</p><p>Best regards,<br>The Team</p>', '2025-11-14 14:02:29'),
(10, 'smtp_enabled', '1', '2025-11-14 14:02:28'),
(11, 'smtp_host', 'smtp.gmail.com', '2025-11-14 14:02:28'),
(12, 'smtp_port', '587', '2025-11-14 14:02:28'),
(13, 'smtp_security', 'tls', '2025-11-14 14:02:28'),
(14, 'smtp_username', 'datasoftcaresales@gmail.com', '2025-11-14 14:02:28'),
(15, 'smtp_password', 'ffhgafnyzwyinujy', '2025-11-14 14:02:28'),
(16, 'smtp_from_email', 'datasoftcaresales@gmail.com', '2025-11-14 14:02:28'),
(17, 'smtp_from_name', 'VPN Panel', '2025-11-14 14:02:28'),
(27, 'gmail_username', 'datasoftcaresales@gmail.com', '2025-11-14 14:02:28'),
(26, 'gmail_enabled', '0', '2025-11-14 14:02:28'),
(18, 'bulk_email_enabled', '1', '2025-11-12 14:37:43'),
(19, 'bulk_email_per_batch', '50', '2025-11-12 14:37:43'),
(20, 'bulk_email_delay', '5', '2025-11-12 14:37:43'),
(21, 'bulk_email_from_name', 'VPN Panel', '2025-11-12 14:37:43'),
(22, 'bulk_email_reply_to', '', '2025-11-12 14:37:43'),
(23, 'email_tracking_enabled', '1', '2025-11-12 14:37:43'),
(24, 'email_unsubscribe_enabled', '1', '2025-11-12 14:37:43'),
(25, 'smtp_type', 'gmail', '2025-11-14 14:02:28'),
(28, 'gmail_from_name', 'VPN Panel System', '2025-11-14 14:02:28'),
(29, 'webmail_host', 'mail.ruzain.com', '2025-11-14 14:02:28'),
(30, 'webmail_port', '587', '2025-11-14 14:02:28'),
(31, 'webmail_security', 'tls', '2025-11-14 14:02:28'),
(32, 'webmail_username', 'info@ruzain.com', '2025-11-14 14:02:28'),
(33, 'webmail_password', '', '2025-11-14 14:02:28'),
(34, 'webmail_from_name', 'VPN Panel', '2025-11-14 14:02:28');

-- --------------------------------------------------------

--
-- Table structure for table `security_logs`
--

CREATE TABLE `security_logs` (
  `id` int(11) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `details` text DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `request_uri` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `security_settings`
--

CREATE TABLE `security_settings` (
  `id` int(11) NOT NULL,
  `setting_name` varchar(100) NOT NULL,
  `setting_value` text NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `security_settings`
--

INSERT INTO `security_settings` (`id`, `setting_name`, `setting_value`, `updated_at`) VALUES
(1, 'ddos_threshold', '100', '2025-12-07 22:33:21'),
(2, 'max_login_attempts', '5', '2025-12-07 22:33:21'),
(3, 'lockout_time', '900', '2025-12-07 22:33:21'),
(4, 'enable_csrf', '1', '2025-12-07 22:33:21'),
(5, 'enable_xss_protection', '1', '2025-12-07 22:33:21'),
(6, 'enable_sql_injection_protection', '1', '2025-12-07 22:33:21'),
(7, 'enable_file_upload_validation', '1', '2025-12-07 22:33:21'),
(8, 'blocked_user_agents', 'bot,crawler,spider,scraper', '2025-12-07 22:33:21'),
(9, 'whitelist_ips', '127.0.0.1,::1', '2025-12-07 22:33:21');

-- --------------------------------------------------------

--
-- Table structure for table `server_list`
--

CREATE TABLE `server_list` (
  `server_id` int(255) NOT NULL,
  `server_name` varchar(255) NOT NULL,
  `server_ip` varchar(20) NOT NULL,
  `server_user` varchar(50) NOT NULL,
  `server_pass` varchar(255) NOT NULL,
  `flag` varchar(10) NOT NULL,
  `a_id` varchar(55) NOT NULL,
  `ns_id` varchar(55) NOT NULL,
  `auth_str` varchar(55) NOT NULL,
  `port_tcp` int(11) NOT NULL,
  `port_udp` int(11) NOT NULL,
  `port_ssh` int(11) NOT NULL,
  `hysteria_port` int(11) NOT NULL,
  `xray_port` int(11) NOT NULL,
  `socksip_port` varchar(11) NOT NULL,
  `xray_tls` int(11) NOT NULL,
  `xray_ntls` int(11) NOT NULL,
  `slowdns_port` int(11) NOT NULL,
  `ssh_port` int(11) NOT NULL,
  `dropbear_port` int(11) NOT NULL,
  `protocol` int(11) NOT NULL,
  `online` int(11) NOT NULL,
  `hysteria_online` int(11) NOT NULL,
  `ssh_online` int(11) NOT NULL,
  `cpu_model` varchar(55) NOT NULL,
  `distro` varchar(55) NOT NULL,
  `memory` varchar(50) NOT NULL,
  `uptime` varchar(30) NOT NULL,
  `disk` varchar(30) NOT NULL,
  `bandwidth` varchar(50) NOT NULL,
  `os` varchar(25) NOT NULL,
  `proto` varchar(30) NOT NULL,
  `tcpssl` varchar(25) NOT NULL,
  `udpssl` varchar(25) NOT NULL,
  `tcp_status` varchar(10) NOT NULL,
  `udp_status` varchar(10) NOT NULL,
  `ssl_status` varchar(10) NOT NULL,
  `squid_status` varchar(10) NOT NULL,
  `socket_status` varchar(10) NOT NULL,
  `hysteria_status` varchar(10) NOT NULL,
  `xray_status` varchar(10) NOT NULL,
  `slowdns_status` varchar(10) NOT NULL,
  `ssh_status` varchar(10) NOT NULL,
  `dropbear_status` varchar(10) NOT NULL,
  `socksip_status` varchar(11) NOT NULL,
  `xray_vmess` varchar(11) NOT NULL,
  `xray_vless` varchar(11) NOT NULL,
  `xray_trojan` varchar(11) NOT NULL,
  `xray_ss` varchar(11) NOT NULL,
  `tcp` varchar(25) NOT NULL,
  `udp` varchar(25) NOT NULL,
  `squid` varchar(25) NOT NULL,
  `socket` varchar(25) NOT NULL,
  `status` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `site_options`
--

CREATE TABLE `site_options` (
  `id` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(155) NOT NULL,
  `logo` varchar(155) NOT NULL,
  `logo_status` int(10) NOT NULL,
  `maintenance_status` int(10) NOT NULL,
  `prefix_status` int(11) NOT NULL,
  `prefix` varchar(50) NOT NULL,
  `trial_duration` int(25) NOT NULL,
  `owner` varchar(50) NOT NULL,
  `theme` varchar(50) NOT NULL,
  `login_note` varchar(256) NOT NULL,
  `session_limit` int(10) NOT NULL,
  `dns_prefix` varchar(155) NOT NULL,
  `dns_domain` varchar(155) NOT NULL,
  `dns_global` varchar(155) NOT NULL,
  `dns_zone` varchar(155) NOT NULL,
  `dns_email` varchar(155) NOT NULL,
  `site_status` int(11) NOT NULL,
  `github_username` varchar(155) NOT NULL,
  `github_token` varchar(155) NOT NULL,
  `github_repo` varchar(255) DEFAULT NULL,
  `update_json` varchar(155) NOT NULL,
  `license` varchar(155) NOT NULL,
  `bak_to` varchar(155) NOT NULL,
  `bak_cc` varchar(155) NOT NULL,
  `otp_code` varchar(11) NOT NULL,
  `otp_id` varchar(11) NOT NULL,
  `otp_duration` int(11) NOT NULL,
  `otp_rsnd` varchar(50) NOT NULL,
  `turnstile_key` varchar(55) NOT NULL,
  `turnstile_secret` varchar(55) NOT NULL,
  `hits` int(11) NOT NULL,
  `whois_api` varchar(50) NOT NULL,
  `bandwidth_limit` int(11) DEFAULT 0,
  `xray_limit` varchar(20) DEFAULT 'disabled',
  `bandwidth_value` decimal(10,2) DEFAULT 0.00,
  `bandwidth_unit` varchar(10) DEFAULT 'gb'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `site_options`
--

INSERT INTO `site_options` (`id`, `email`, `name`, `description`, `logo`, `logo_status`, `maintenance_status`, `prefix_status`, `prefix`, `trial_duration`, `owner`, `theme`, `login_note`, `session_limit`, `dns_prefix`, `dns_domain`, `dns_global`, `dns_zone`, `dns_email`, `site_status`, `github_username`, `github_token`, `github_repo`, `update_json`, `license`, `bak_to`, `bak_cc`, `otp_code`, `otp_id`, `otp_duration`, `otp_rsnd`, `turnstile_key`, `turnstile_secret`, `hits`, `whois_api`, `bandwidth_limit`, `xray_limit`, `bandwidth_value`, `bandwidth_unit`) VALUES
(1, 'azimaxus@gmail.com', 'Vollam', 'Fast and Secure', '1763767623.png', 1, 0, 0, 'vip', 7200, 'Vollam', 'purple', 'cW5vRi8vU1hsYVk0Um1vdXo3MTlmQT09', 99999, '', 'jaeAZs3OqOTM09ualc+kj6ultIa4wmvhf4aE54W1nJM=', 'j7urnNi7sbfbq9eRfqjJeKSp1pa8w5Whh6umpou4z46dyZ6tipR4jazTfuizupnJgt2Uk4a8vKq6oKSizcCAq9K/dp60ud3puomIrqy6u9yGvLq+zaeqkw==', 'kNG/Z9qqtdzL0r2Yfs6PoJeW2qe5wIy6fIeZ5ZWo5MS3louDhruDeK6Mha2sqbvBfN16w4Wswaq5sMKgv6iWssODisWekr+lu8Gcw66ToJ2Jo5jHw82qkw==', 'is27ftm5k9vJqcR2hJHFdp6DvIa+nZq2f5p07YbMuYurybCnlqamiZjGgqyoqLvDk8+gf5a5z4Gnroat', 1, 'vollams', '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', 'ruzain.com', 'https://ruzain.com', 'ADMIN-9194D344-28CAF5F7', 'azimaxus@gmail.com', 'azimaxus@gmail.com', '', '', 0, '', '0x4AAAAAAB12VfPkRndAiEbc', '0x4AAAAAAB12VR34JJpaXjqrHy5D8f0FA0A', 587, 'F8PVAPHDTFSHEhHHJmH06uyJX5lQYtxB', 2147483647, 'disabled', '90.00', 'gb');

-- --------------------------------------------------------

--
-- Table structure for table `slider_images`
--

CREATE TABLE `slider_images` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(255) NOT NULL,
  `link_url` varchar(500) DEFAULT NULL,
  `sort_order` int(11) DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `slider_images`
--

INSERT INTO `slider_images` (`id`, `title`, `description`, `image_url`, `link_url`, `sort_order`, `status`, `created_at`, `updated_at`) VALUES
(1, '50% offer', 'Reseller Get this offer', 'slider_1765056736_6934a0e08c715.jpg', 'https://ruzain.com', 1, 'active', '2025-12-06 21:08:22', '2025-12-06 21:32:16'),
(3, 'Best Speed Server', '100+ Server', 'slider_1765056833_6934a141d9c6d.jpg', 'https://ruzain.com', 3, 'active', '2025-12-06 21:24:31', '2025-12-06 21:33:53'),
(4, 'Premium VPN', 'High Speed VPN', 'slider_1765056790_6934a116cfdb5.jpg', 'https://ruzain.com', 2, 'active', '2025-12-06 21:28:39', '2025-12-06 21:33:10');

-- --------------------------------------------------------

--
-- Table structure for table `subscriber_config`
--

CREATE TABLE `subscriber_config` (
  `id` int(11) NOT NULL,
  `subscriber_id` int(11) NOT NULL,
  `email_frequency` enum('daily','weekly','monthly','never') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'weekly',
  `email_format` enum('html','text') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'html',
  `marketing_emails` tinyint(1) NOT NULL DEFAULT 1,
  `newsletter` tinyint(1) NOT NULL DEFAULT 1,
  `product_updates` tinyint(1) NOT NULL DEFAULT 1,
  `created_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_message`
--

CREATE TABLE `support_message` (
  `id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `support_message` text NOT NULL,
  `support_id_user` int(11) NOT NULL,
  `support_name` varchar(767) NOT NULL,
  `support_groupname` varchar(767) NOT NULL,
  `support_date` datetime NOT NULL,
  `support_ipaddress` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `support_ticket`
--

CREATE TABLE `support_ticket` (
  `id` int(11) NOT NULL,
  `ticket_name` varchar(767) NOT NULL,
  `ticket_subject` varchar(767) NOT NULL,
  `ticket_message` text NOT NULL,
  `ticket_status` enum('open','customer-reply','answered','closed') NOT NULL,
  `ticket_date` datetime NOT NULL,
  `ticket_update` datetime NOT NULL,
  `ip_address` varchar(767) NOT NULL,
  `ticket_id_user` int(11) NOT NULL,
  `ticket_groupname` varchar(767) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `suspension_logs`
--

CREATE TABLE `suspension_logs` (
  `id` int(11) NOT NULL,
  `is_suspended` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `client_username` varchar(32) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(32) NOT NULL,
  `offense` varchar(225) NOT NULL,
  `logs_date` datetime NOT NULL,
  `ipaddress` varchar(32) NOT NULL DEFAULT '0.0.0.0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `suspension_recovery_logs`
--

CREATE TABLE `suspension_recovery_logs` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `client_username` varchar(32) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(32) NOT NULL,
  `suspend_date` datetime NOT NULL,
  `offense` varchar(225) NOT NULL,
  `logs_date` datetime NOT NULL,
  `is_unsuspended` int(11) NOT NULL,
  `ipaddress` varchar(32) NOT NULL DEFAULT '0.0.0.0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `username_logs`
--

CREATE TABLE `username_logs` (
  `id` int(11) NOT NULL,
  `old_username` varchar(50) NOT NULL,
  `new_username` varchar(50) NOT NULL,
  `old_level` varchar(64) NOT NULL,
  `new_level` varchar(64) NOT NULL,
  `old_upline` int(11) NOT NULL,
  `new_upline` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `logs_date` datetime NOT NULL,
  `ipaddress` varchar(32) NOT NULL DEFAULT '0.0.0.0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `password` varchar(50) NOT NULL DEFAULT 'jho',
  `code` varchar(10) NOT NULL,
  `ss_id` varchar(64) NOT NULL,
  `ssl_id` varchar(50) NOT NULL DEFAULT 'ssl',
  `username_prefix` varchar(11) NOT NULL,
  `user_name` varchar(30) NOT NULL DEFAULT '',
  `user_pass` varchar(256) NOT NULL,
  `user_2fa` int(11) NOT NULL,
  `user_2fa_otp` varchar(11) NOT NULL,
  `user_2fa_id` varchar(11) NOT NULL,
  `user_2fa_duration` int(11) NOT NULL,
  `attribute` varchar(64) NOT NULL DEFAULT 'MD5-Password',
  `op` char(2) NOT NULL DEFAULT ':=',
  `auth_vpn` varchar(256) NOT NULL,
  `user_email` varchar(50) NOT NULL DEFAULT '',
  `mobile` varchar(20) DEFAULT NULL,
  `user_email_verified` int(11) NOT NULL,
  `full_name` varchar(50) DEFAULT NULL,
  `regdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ipaddress` varchar(50) NOT NULL DEFAULT '0.0.0.0',
  `lastlogin` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `timestamp` int(11) NOT NULL,
  `reset_code` varchar(255) NOT NULL DEFAULT '0',
  `is_groupname` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `is_freeze` tinyint(1) NOT NULL DEFAULT 1,
  `is_passchange` int(11) NOT NULL,
  `passchange_duration` int(25) NOT NULL,
  `last_freeze_date` datetime NOT NULL,
  `is_validated` tinyint(1) NOT NULL DEFAULT 0,
  `is_connected` int(1) NOT NULL DEFAULT 0,
  `is_offense` int(11) NOT NULL DEFAULT 0,
  `is_ban` int(11) NOT NULL DEFAULT 1,
  `is_socksip` int(11) NOT NULL,
  `user_group` int(100) NOT NULL,
  `suspended_date` datetime NOT NULL,
  `duration` bigint(50) NOT NULL DEFAULT 18000,
  `vip_duration` bigint(50) NOT NULL,
  `is_vip` int(11) NOT NULL DEFAULT 0,
  `private_duration` bigint(50) NOT NULL DEFAULT 0,
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `private_slot` int(11) NOT NULL DEFAULT 0,
  `private_control` tinyint(1) NOT NULL DEFAULT 0,
  `credits` int(20) NOT NULL DEFAULT 0,
  `upline` int(10) NOT NULL DEFAULT 1,
  `login_status` enum('offline','online') NOT NULL DEFAULT 'offline',
  `last_active_time` datetime NOT NULL,
  `user_level` enum('normal','subreseller','reseller','administrator','subadmin','superadmin','bulk','trial','developer') NOT NULL,
  `status` enum('live','freeze','suspended','banned','vacation') NOT NULL DEFAULT 'live',
  `bytes_received` int(55) NOT NULL,
  `bytes_sent` int(55) NOT NULL,
  `bandwidth` int(11) NOT NULL DEFAULT 0,
  `bandwidth_premium` int(11) NOT NULL,
  `bandwidth_vip` int(11) NOT NULL,
  `bandwidth_ph` int(11) NOT NULL,
  `bandwidth_private` int(11) NOT NULL,
  `bandwidth_free` int(11) NOT NULL,
  `device_connected` int(2) NOT NULL DEFAULT 0,
  `device_id` varchar(100) NOT NULL,
  `device_model` varchar(100) NOT NULL,
  `session` int(50) NOT NULL,
  `active_address` varchar(25) NOT NULL,
  `active_date` datetime NOT NULL,
  `bandwidth_used` bigint(20) UNSIGNED DEFAULT 0,
  `api_key` varchar(64) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `password`, `code`, `ss_id`, `ssl_id`, `username_prefix`, `user_name`, `user_pass`, `user_2fa`, `user_2fa_otp`, `user_2fa_id`, `user_2fa_duration`, `attribute`, `op`, `auth_vpn`, `user_email`, `mobile`, `user_email_verified`, `full_name`, `regdate`, `ipaddress`, `lastlogin`, `timestamp`, `reset_code`, `is_groupname`, `is_active`, `is_freeze`, `is_passchange`, `passchange_duration`, `last_freeze_date`, `is_validated`, `is_connected`, `is_offense`, `is_ban`, `is_socksip`, `user_group`, `suspended_date`, `duration`, `vip_duration`, `is_vip`, `private_duration`, `is_private`, `private_slot`, `private_control`, `credits`, `upline`, `login_status`, `last_active_time`, `user_level`, `status`, `bytes_received`, `bytes_sent`, `bandwidth`, `bandwidth_premium`, `bandwidth_vip`, `bandwidth_ph`, `bandwidth_private`, `bandwidth_free`, `device_connected`, `device_id`, `device_model`, `session`, `active_address`, `active_date`, `bandwidth_used`, `api_key`) VALUES
(1, 'hjhj', '405154310', '54090', 'any', '', 'admin', 'RzY5bFdnQlp4ZGRzeGdQKzdWbld0QT09', 0, 'LKRCAP0YN', 'SCK24IB6C', 600, 'MD5-Password', ':=', 'd7bf22ec761d8ec6c446bda4a1c1affa', 'admin@localhost.com', NULL, 0, 'VPN Philippines', '2018-07-09 10:59:14', '::1', '2026-03-29 12:03:22', 0, '0', 'superadmin', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 33696000, 1305000, 1, 1728000, 1, 0, 0, 1000, 1, 'online', '2026-03-29 12:03:22', 'superadmin', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, '9294a5b04fa380233079e139f38d54fc09103d252853807b42a6bf6adea42f15'),
(2, 'hjhj', '405154310', '54090', 'any', '', 'developer', 'RzY5bFdnQlp4ZGRzeGdQKzdWbld0QT09', 0, '', '', 0, 'MD5-Password', ':=', 'd7bf22ec761d8ec6c446bda4a1c1affa', 'azimaxus@gmail.com', NULL, 0, 'Vollam Developer', '2018-07-09 10:59:14', '::1', '2026-03-29 11:53:18', 0, '0', 'developer', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 999999, 1305000, 1, 1728000, 1, 0, 0, 1000, 1, 'offline', '2026-03-29 11:53:18', 'developer', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58271, 'jho', '129091414', '', 'ssl', '', '51357', 'c3AxSWNGeGh1QlZ0ZzkyUTFnL1JQQT09', 0, '', '', 0, 'MD5-Password', ':=', '3d061cf70f5c2ecd88c60e7779570e1c', '51357gmail.com', NULL, 0, 'Normal User', '2025-12-08 10:03:21', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58166, 'jho', '713756799', '', 'ssl', '', '37185', 'S2xiOUY5ZERYRWFON20yWEhLaFhSQT09', 0, '', '', 0, 'MD5-Password', ':=', '74a14dc6be3d469770f53dd3fb93c6c4', '37185gmail.com', NULL, 0, 'Normal User', '2025-12-08 01:13:54', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58165, 'jho', '201314357', '', 'ssl', '', '55402', 'em5LV1VMQ1lNRzRIcHp5Qlo4VzBzZz09', 0, '', '', 0, 'MD5-Password', ':=', '7d7733c8d01b7352aab3990d99d89d8e', '55402gmail.com', NULL, 0, 'Normal User', '2025-12-08 01:13:21', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58267, 'jho', '674066981', '', 'ssl', '', 'dev11', 'Q0oxdDZOdVFtVDJaZXhFNjdXN0srdz09', 0, '', '', 0, 'MD5-Password', ':=', '1c082f75be8b52471e19bc82800a2f47', 'dev11gmail.com', NULL, 0, 'Normal User', '2025-12-08 09:01:37', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58268, 'jho', '600992437', '', 'ssl', '', 'dev22', 'RlZ5Y0dYSmNCbGttVzVMR3p5YzV1dz09', 0, '', '', 0, 'MD5-Password', ':=', '9f61662bc977accb779f9bac4f627e15', 'dev22gmail.com', NULL, 0, 'Normal User', '2025-12-08 09:01:45', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1411800, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '7a8ce2152a429f86', 'CPH2343', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58269, 'jho', '964593794', '', 'ssl', '', 'dev33', 'RGswaUJXNDhGM3lJVjN6azdVSmIvUT09', 0, '', '', 0, 'MD5-Password', ':=', 'f29110a8fda2ae3c6dd5d821c0100090', 'dev33gmail.com', NULL, 0, 'Normal User', '2026-01-29 21:38:32', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 1, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 6743700, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '7a8ce2152a429f86', 'CPH2343', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58272, 'jho', '987158702', '', 'ssl', '', '52444', 'dklaanpwZEFIZktqTElNUlhqbzRIdz09', 0, '', '', 0, 'MD5-Password', ':=', 'c555dbde389bd6187d14fc87517ce6c0', '52444gmail.com', NULL, 0, 'Normal User', '2025-12-09 01:37:34', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58273, 'jho', '900528523', '', 'ssl', '', '11780', 'Q3g1dzYxV3ZCbXZvVkoyWjJ0NVV0Zz09', 0, '', '', 0, 'MD5-Password', ':=', 'b270a720f6ac2e8a8c53d968243d5971', '11780gmail.com', NULL, 0, 'Normal User', '2025-12-24 07:30:25', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1422900, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '54e617aa5b171f67', 'V2333', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58274, 'jho', '5745129', '', 'ssl', '', 'dev55', 'emFQSXdtTUpacEFzRGprTkkvZC9Tdz09', 0, '', '', 0, 'MD5-Password', ':=', '3cba62c6370189525bd68c6e9b4b50bb', 'dev55gmail.com', NULL, 0, 'Normal User', '2025-12-24 07:30:57', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1421400, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, 'bb6f537fdfb20536', 'SM-A716B', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58275, 'jho', '846574950', '', 'ssl', '', 'dev44', 'b2NFbWlMVTcyMG5za2NFVVY0VzVHdz09', 0, '', '', 0, 'MD5-Password', ':=', 'df348474803ce1801cb7bd7b95d76371', 'dev44gmail.com', NULL, 0, 'Normal User', '2025-12-24 07:31:41', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1435200, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58276, 'jho', '480862876', '', 'ssl', '', 'udpuser', 'OWFmbGxySzc1VWpHcUJjWTNoYzdwZz09', 0, '', '', 0, 'MD5-Password', ':=', '131326222d339acfc8dfa68207ab5a86', 'udpusergmail.com', NULL, 0, 'Normal User', '2025-12-24 07:31:50', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58290, 'jho', '421065531', '', 'ssl', '', 'user147116', 'S1Y5allXQlV3bUpZZW9LOHlXeEpnQT09', 0, '', '', 0, 'MD5-Password', ':=', 'bc0cb8bacdf107cee0f940fd20d1878c', 'user147116@user.com', NULL, 0, 'Normal User', '2025-12-24 21:15:52', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58291, 'jho', '516468062', '', 'ssl', '', 'user454462', 'LzRQRXIveWZoYVk3aFlGNVBxUzFxdz09', 0, '', '', 0, 'MD5-Password', ':=', 'a6563d91bb29031b4e047c6b6e224022', 'user454462@user.com', NULL, 0, 'Normal User', '2025-12-24 21:20:55', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58292, 'jho', '636318644', '', 'ssl', '', 'user613499', 'NjVtcEdiaTY5U25OMEpUTHFOb0JCZz09', 0, '', '', 0, 'MD5-Password', ':=', '38522731b688888096733b21180f91a4', 'user613499@user.com', NULL, 0, 'Normal User', '2025-12-24 21:23:34', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58293, 'jho', '232475931', '', 'ssl', '', 'testuser1766600863', 'cTR2NlNWWlZZUURKREdYZ0J6NGFGUT09', 0, '', '', 0, 'MD5-Password', ':=', '32250170a0dca92d53ec9624f336ca24', 'testuser1766600863@test.com', '1234567890', 0, 'Test User', '2025-12-24 21:27:44', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 1, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58294, 'jho', '126710247', '', 'ssl', '', 'user897439', 'dlFYVkREdG9hYk9xNW9xMS9MSm5Ldz09', 0, '', '', 0, 'MD5-Password', ':=', '79ff220004bd2fc071d23334f2329b3e', 'user897439@user.com', NULL, 0, 'Normal User', '2025-12-24 21:28:19', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58295, 'jho', '460393606', '', 'ssl', '', 'testuser1766600915', 'cTR2NlNWWlZZUURKREdYZ0J6NGFGUT09', 0, '', '', 0, 'MD5-Password', ':=', '32250170a0dca92d53ec9624f336ca24', 'testuser1766600915@test.com', '1234567890', 0, 'Test User', '2025-12-24 21:28:35', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 1, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58296, 'jho', '788172543', '', 'ssl', '', 'azimaxu', 'QlJoQ1U5dXViYi9KQUR4NWVodjJ2UT09', 0, '', '', 0, 'MD5-Password', ':=', '78f0fc13cbcdf83265856ef550169936', 'azimaxugmail.com', NULL, 0, 'Normal User', '2025-12-24 09:37:28', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58297, 'jho', '446049600', '', 'ssl', '', '21079', 'NERjMktvRVhnL3Y1ZTBscWlCclB1UT09', 0, '', '', 0, 'MD5-Password', ':=', 'f775ec264c01adf8189da19ec86676fe', '21079gmail.com', NULL, 0, 'Normal User', '2025-12-26 09:22:27', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1470900, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58317, 'jho', '847076367', '', 'ssl', '', 'saiful', 'd1FvcTlaR3ZqclRRTWl3RHRUL05LZz09', 0, '', '', 0, 'MD5-Password', ':=', '3a029f04d76d32e79367c4b3255dda4d', 'saiful@email.com', NULL, 0, 'Reseller User', '2026-01-08 12:00:25', '31.166.248.190', '2026-02-02 09:44:58', 0, '0', 'reseller', 1, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, 0, 0, 0, 0, 0, 0, 98, 1, 'online', '2026-02-02 09:44:58', 'reseller', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58298, 'jho', '138760101', '', 'ssl', '', 'dev99', 'NzdJcFNuVGRKU2pZS3A4M2N2ZUVSZz09', 0, '', '', 0, 'MD5-Password', ':=', 'ee6f82bd901df5f8aab8393ab5b3ec6d', 'dev99gmail.com', NULL, 0, 'Normal User', '2025-12-27 11:24:15', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1502100, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '8053bdd7589f64dc', 'CPH2343', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58323, 'jho', '518969865', '', 'ssl', '', '42655', 'N0xPOWRQUzdyeTkxQytneVpoaGh1Zz09', 0, '', '', 0, 'MD5-Password', ':=', 'd01d080783ec584fbcdeda594b17b442', '42655gmail.com', NULL, 0, 'Normal User', '2026-01-11 08:35:50', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1930500, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '47e1dacf807054ad', 'CPH2585', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58299, 'jho', '495226293', '', 'ssl', '5fjs', '5fjs51', 'aGdtNHdDUWZUT3lBaVl3NnVWVFVZZz09', 0, '', '', 0, 'MD5-Password', ':=', '2c743f2d4e76731333c43e8f5562f687', '5fjs877620gmail.com', NULL, 0, 'Bulk User', '2025-12-29 07:52:47', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'bulk', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 49232, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'bulk', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58300, 'jho', '881116138', '', 'ssl', '3xaz', '3xaz31', 'L28zQnB4S2JrelVIbUZ2Mmh4UTkxdz09', 0, '', '', 0, 'MD5-Password', ':=', '9cce2801a113e00715ecab901ca6e121', '3xaz86785gmail.com', NULL, 0, 'Bulk User', '2025-12-29 08:06:09', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'bulk', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 34580, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'bulk', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58301, 'jho', '265536843', '', 'ssl', '', '30524', 'WnpYQUZvbnpQWVNmMGZCY1RpcHQ2QT09', 0, '', '', 0, 'MD5-Password', ':=', '6b241f2fd1f3e9b34b6b558de1b42142', '30524gmail.com', NULL, 0, 'Normal User', '2025-12-29 03:30:57', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58305, 'jho', '126018281', '', 'ssl', '', 'ibrahim', 'TVBiVjI2WWJaSStBU2ZJUE9JTUF4Zz09', 0, '', '', 0, 'MD5-Password', ':=', 'ef80af910fa07870e25b1a4c86d10402', 'ibrahim@email.com', NULL, 0, 'Reseller User', '2026-01-01 01:16:07', '2001:16a4:291:dfb5:df42:7924:eb18:426a', '2026-01-01 13:06:27', 0, '0', 'reseller', 1, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, 0, 0, 0, 0, 0, 0, 50, 1, 'online', '2026-01-01 13:06:27', 'reseller', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58303, 'jho', '191201217', '', 'ssl', '', 'azimgvgv', 'K2dHVVlFbkhTenQ1RVVHbFBZSFhSUT09', 0, '', '', 0, 'MD5-Password', ':=', 'd54d1702ad0f8326224b817c796763c9', 'azimaxcom@gmail.com', '0598126771', 0, 'azim', '2025-12-29 23:03:49', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 1, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58320, 'jho', '62965712', '', 'ssl', '', '13366', 'bnFKdFlMdnNtVG9XT3BSTTJOM3hEdz09', 0, '', '', 0, 'MD5-Password', ':=', '52ab2988c90e81715008ed5189632b8d', '13366gmail.com', NULL, 0, 'Normal User', '2026-01-08 12:31:44', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', 1845300, 0, 0, 0, 0, 0, 0, 0, 58317, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, 'a790d4ae4dba82f4', 'itel A671LC', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58319, 'jho', '620514234', '', 'ssl', '', '55921', 'aGREV05wRkxSRlZ5a0FqSVhudERMZz09', 0, '', '', 0, 'MD5-Password', ':=', '366893c13ae0d73de4dfeaf64a9d86dd', '55921gmail.com', NULL, 0, 'Normal User', '2026-01-08 12:20:02', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1819800, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, 'a790d4ae4dba82f4', 'itel A671LC', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58341, 'jho', '314339761', '', 'ssl', '', '73224', 'K3ZhYUhBUTBGWXFNeEVJTTJybkRpUT09', 0, '', '', 0, 'MD5-Password', ':=', '9f6c425b71df66aa20ff08042ad059d9', '73224gmail.com', NULL, 0, 'Normal User', '2026-03-26 10:48:57', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58316, 'jho', '880609125', '', 'ssl', '', '98284', 'ck5nM01kZ3Z0VUJOeVdlMXJwYmxmdz09', 0, '', '', 0, 'MD5-Password', ':=', '9ae7e87078e4f2437e9bb95707c994dd', '98284gmail.com', NULL, 0, 'Normal User', '2026-01-04 03:58:21', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1723800, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, 'f354e74d795689e7', '23129RAA4G', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58322, 'jho', '812523837', '', 'ssl', '', 'masud2', 'ZFhscGpTMEx1dG5jWkVBaVdUb1B5UT09', 0, '', '', 0, 'MD5-Password', ':=', '294a43e99f4567c1cafcb35596eb602a', 'masud2gmail.com', NULL, 0, 'Normal User', '2026-01-09 02:46:17', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1866000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '31ec5511568ce73d', 'SM-A715F', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58324, 'jho', '313744101', '', 'ssl', '', 'dev00', 'RDVyRjh0ZVpqaEkwaWpySzNseURrZz09', 0, '', '', 0, 'MD5-Password', ':=', 'e8df285834891a90adc5da4d8c2d9627', 'dev00gmail.com', NULL, 0, 'Normal User', '2026-01-12 10:42:58', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1947600, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, 'AA0A5964-7C09-4A8B-8D13-E9E38FA1872F', 'iPhone', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58325, 'jho', '602448663', '', 'ssl', '', 'dev88', 'WndIRlBuN2pZb1h6QThMOFAzWHhqdz09', 0, '', '', 0, 'MD5-Password', ':=', '7e51b45a440163dfc00574da5ab600a8', 'dev88gmail.com', NULL, 0, 'Normal User', '2026-01-14 01:18:41', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2008200, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, 'AA0A5964-7C09-4A8B-8D13-E9E38FA1872F', 'iPhone', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58326, 'jho', '738668670', '', 'ssl', '', '90749', 'SWlQK0dnbVBvdHFNZkdhWmNGMElJdz09', 0, '', '', 0, 'MD5-Password', ':=', 'd268b0dbb2e73d998de3278721bf44dc', '90749gmail.com', NULL, 0, 'Normal User', '2026-01-16 10:32:29', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2076900, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, 'fa6578ae3df4ce3c', 'SM-A528B', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58338, 'jho', '645048079', '', 'ssl', '', '41132', 'M0VQdDBIKzJpQmJTNTZ2b3FwUmZLdz09', 0, '', '', 0, 'MD5-Password', ':=', '6b08cb11fb528ea9a29c488857b93c36', '41132gmail.com', NULL, 0, 'Normal User', '2026-01-31 09:11:23', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2506800, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '5bc962ca9177cc18', 'RMO-NX1', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58327, 'jho', '415329341', '', 'ssl', '', '53146', 'b2dBUWYybUpwTzl2Rk9MdEM0NVJUZz09', 0, '', '', 0, 'MD5-Password', ':=', '5c46c77f7e6370b3b95ebfedab5c0176', '53146gmail.com', NULL, 0, 'Normal User', '2026-01-19 01:05:32', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58328, 'jho', '699607850', '', 'ssl', '', 'jeddah', 'bVk5c3JDNGZpUUdVa1pzZkpaazlNdz09', 0, '', '', 0, 'MD5-Password', ':=', '0e9212587d373ca58e9bada0c15e6fe4', 'jeddah@email.com', NULL, 0, 'Reseller User', '2026-01-19 01:07:06', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'reseller', 1, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, 0, 0, 0, 0, 0, 0, 1, 1, 'offline', '0000-00-00 00:00:00', 'reseller', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58330, 'jho', '477333891', '', 'ssl', '', '56415', 'U1k1OU1hY3VqNWdQZ0ZJM2VQS0U0Zz09', 0, '', '', 0, 'MD5-Password', ':=', 'd80686e7e897bf4d346d5f41ae337e35', '56415gmail.com', NULL, 0, 'Normal User', '2026-01-21 12:18:01', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2208600, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '27211d1596b3f9cb', 'M2101K6G', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58339, 'jho', '395940767', '', 'ssl', '', '30310', 'Wkk5bUcxSi9tVlFKOGxwa0puNmdIQT09', 0, '', '', 0, 'MD5-Password', ':=', 'a6b032cc13e531b6fc9824b18154da41', '30310gmail.com', NULL, 0, 'Normal User', '2026-01-31 09:11:31', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2506800, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '5bc962ca9177cc18', 'RMO-NX1', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58337, 'jho', '510335526', '', 'ssl', '', 'saiful22', 'SEc1TTVYcDNsTktPUnJGV291WHMrdz09', 0, '', '', 0, 'MD5-Password', ':=', '306709671e0673534b400567f6950910', 'saiful22gmail.com', NULL, 0, 'Normal User', '2026-01-23 09:24:33', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2277000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, 'edcfa375f5fb0486', 'SM-A366B', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58334, 'jho', '880723271', '', 'ssl', '', '43964', 'VENzR25MeEFheEJDbUtyYVlPa2hIZz09', 0, '', '', 0, 'MD5-Password', ':=', 'a2df68e0d5615e70a958834e914a09bc', '43964gmail.com', NULL, 0, 'Normal User', '2026-01-21 02:36:27', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2211300, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, '30aa224392aec544', 'SM-S918B', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58340, 'jho', '122650862', '', 'ssl', '', '32610', 'eHluNTVQZTQrSXIvRVp5ZElPNWcrUT09', 0, '', '', 0, 'MD5-Password', ':=', '9d4fba46fb8cef375e5b9021fa54d0aa', '32610gmail.com', NULL, 0, 'Normal User', '2026-02-02 05:49:06', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2560200, 0, 0, 0, 0, 0, 0, 0, 58317, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 1, 'f445becd830fe49a', 'V2430', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58342, 'jho', '285719650', '', 'ssl', '', '21549', 'Wk84RmdlOVFBV1VJK21qL3R3dWNaUT09', 0, '', '', 0, 'MD5-Password', ':=', '51cabf7cb19df57c46a747971bd9db37', '21549gmail.com', NULL, 0, 'Normal User', '2026-03-27 05:07:53', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL),
(58343, 'jho', '986502255', '', 'ssl', '', '16390', 'V0ljMUl2Q2Rua05MeG9BQXRiajFDUT09', 0, '', '', 0, 'MD5-Password', ':=', '48b8591eb23fd3ec3d932caf82d81144', '16390gmail.com', NULL, 0, 'Normal User', '2026-03-27 05:08:00', '0.0.0.0', '0000-00-00 00:00:00', 0, '0', 'normal', 0, 0, 0, 0, '0000-00-00 00:00:00', 1, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 2592000, 0, 0, 0, 0, 0, 0, 0, 1, 'offline', '0000-00-00 00:00:00', 'normal', 'live', 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 0, '', '0000-00-00 00:00:00', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users_delete`
--

CREATE TABLE `users_delete` (
  `id` int(11) NOT NULL,
  `delete_timestamp` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(30) NOT NULL DEFAULT '',
  `user_pass` varchar(256) NOT NULL,
  `auth_vpn` varchar(256) NOT NULL,
  `user_email` varchar(50) NOT NULL DEFAULT '',
  `full_name` varchar(50) DEFAULT NULL,
  `regdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ipaddress` varchar(50) NOT NULL DEFAULT '0.0.0.0',
  `lastlogin` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `timestamp` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `reset_code` varchar(255) NOT NULL DEFAULT '0',
  `is_groupname` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `is_freeze` tinyint(1) NOT NULL DEFAULT 1,
  `last_freeze_date` date NOT NULL,
  `is_validated` tinyint(1) NOT NULL DEFAULT 0,
  `is_connected` int(1) NOT NULL DEFAULT 0,
  `is_offense` int(11) NOT NULL DEFAULT 0,
  `is_ban` int(11) NOT NULL DEFAULT 1,
  `suspended_date` datetime NOT NULL,
  `duration` bigint(50) NOT NULL DEFAULT 7200,
  `vip_duration` bigint(50) NOT NULL,
  `is_vip` int(11) NOT NULL DEFAULT 0,
  `private_duration` bigint(50) NOT NULL DEFAULT 0,
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `private_slot` int(11) NOT NULL DEFAULT 0,
  `private_control` tinyint(1) NOT NULL DEFAULT 0,
  `credits` int(20) NOT NULL DEFAULT 0,
  `upline` int(10) NOT NULL DEFAULT 1,
  `login_status` enum('offline','online') NOT NULL DEFAULT 'offline',
  `last_active_time` datetime NOT NULL,
  `user_level` enum('normal','subreseller','reseller','moderator','subadmin','superadmin','bulk','trial') NOT NULL,
  `status` enum('live','freeze','suspended','banned','vacation') NOT NULL DEFAULT 'live',
  `bandwidth` int(11) NOT NULL DEFAULT 0,
  `bandwidth_premium` int(11) NOT NULL,
  `bandwidth_vip` int(11) NOT NULL,
  `bandwidth_ph` int(11) NOT NULL,
  `bandwidth_private` int(11) NOT NULL,
  `bandwidth_free` int(11) NOT NULL,
  `device_connected` int(2) NOT NULL DEFAULT 0,
  `device_id` varchar(100) NOT NULL,
  `device_model` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_profile`
--

CREATE TABLE `users_profile` (
  `id` int(5) NOT NULL,
  `profile_id` int(5) NOT NULL,
  `profile_fb` varchar(250) NOT NULL,
  `profile_address` varchar(255) NOT NULL,
  `profile_number` varchar(13) NOT NULL DEFAULT '0',
  `profile_image` varchar(255) NOT NULL,
  `first_name` varchar(55) CHARACTER SET latin1 NOT NULL,
  `last_name` varchar(55) CHARACTER SET latin1 NOT NULL,
  `bio_link` varchar(11) CHARACTER SET latin1 NOT NULL,
  `bdo` int(1) NOT NULL DEFAULT 0,
  `bitcoin` int(1) NOT NULL DEFAULT 0,
  `bpi` int(1) NOT NULL DEFAULT 0,
  `cebuana` int(1) NOT NULL DEFAULT 0,
  `gcash` int(1) NOT NULL DEFAULT 0,
  `lbc` int(1) NOT NULL DEFAULT 0,
  `lbp` int(1) NOT NULL DEFAULT 0,
  `meetup` int(1) NOT NULL DEFAULT 0,
  `mlkwartapadala` int(1) NOT NULL DEFAULT 0,
  `palawanexpress` int(1) NOT NULL DEFAULT 0,
  `paypal` int(1) NOT NULL DEFAULT 0,
  `prepaidload` int(1) NOT NULL DEFAULT 0,
  `rcbc` int(1) NOT NULL DEFAULT 0,
  `rdperapadala` int(1) NOT NULL DEFAULT 0,
  `smartmoney` int(1) NOT NULL DEFAULT 0,
  `unionbank` int(1) NOT NULL DEFAULT 0,
  `westernunion` int(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_profile`
--

INSERT INTO `users_profile` (`id`, `profile_id`, `profile_fb`, `profile_address`, `profile_number`, `profile_image`, `first_name`, `last_name`, `bio_link`, `bdo`, `bitcoin`, `bpi`, `cebuana`, `gcash`, `lbc`, `lbp`, `meetup`, `mlkwartapadala`, `palawanexpress`, `paypal`, `prepaidload`, `rcbc`, `rdperapadala`, `smartmoney`, `unionbank`, `westernunion`) VALUES
(1, 1, '', 'Saudi Arabia', '8801874654595', '1762851060.png', 'Vollam', 'Azim', 'OHRXfXKZQ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 2, '', 'Saudi Arabia', '8801874654595', 'avatar-1.png', 'Azim', 'Developer', 'HKWfLXfbG', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(15349, 58304, '', '', '09123456789', '', 'Reseller', 'Account', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(15350, 58305, '', '', '09123456789', '', 'Reseller', 'Account', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(15351, 58317, '', '', '09123456789', '', 'Reseller', 'Account', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(15352, 58328, '', '', '09123456789', '', 'Reseller', 'Account', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `vouchers`
--

CREATE TABLE `vouchers` (
  `id` int(11) NOT NULL,
  `code_name` varchar(50) NOT NULL,
  `user_id` int(100) NOT NULL,
  `client_name` varchar(755) NOT NULL,
  `reseller_id` int(100) NOT NULL,
  `reseller_name` varchar(64) NOT NULL,
  `is_qty` int(11) NOT NULL DEFAULT 1,
  `is_used` int(1) NOT NULL,
  `duration` bigint(50) NOT NULL DEFAULT 0,
  `gen_date` datetime NOT NULL,
  `date_used` datetime NOT NULL,
  `category` enum('premium','vip','private') NOT NULL DEFAULT 'premium',
  `permission` tinyint(1) NOT NULL DEFAULT 0,
  `ipaddress` varchar(32) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `voucher_logs`
--

CREATE TABLE `voucher_logs` (
  `id` int(11) NOT NULL,
  `code_name` varchar(50) NOT NULL,
  `user_id` int(100) NOT NULL,
  `client_name` varchar(755) NOT NULL,
  `reseller_id` int(100) NOT NULL,
  `reseller_name` varchar(64) NOT NULL,
  `is_qty` int(11) NOT NULL DEFAULT 1,
  `is_used` int(1) NOT NULL,
  `date_used` datetime NOT NULL,
  `is_date` date NOT NULL,
  `category` enum('premium','vip','private') NOT NULL DEFAULT 'premium'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_date` (`date`);

--
-- Indexes for table `ads_api_logs`
--
ALTER TABLE `ads_api_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `app_name` (`app_name`),
  ADD KEY `created_date` (`created_date`);

--
-- Indexes for table `ads_apps`
--
ALTER TABLE `ads_apps`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `app_name` (`app_name`),
  ADD UNIQUE KEY `package_name` (`package_name`);

--
-- Indexes for table `ads_revenue`
--
ALTER TABLE `ads_revenue`
  ADD PRIMARY KEY (`id`),
  ADD KEY `app_id` (`app_id`),
  ADD KEY `app_name` (`app_name`),
  ADD KEY `date` (`date`);

--
-- Indexes for table `anti_ddos`
--
ALTER TABLE `anti_ddos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `application`
--
ALTER TABLE `application`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `app_notices`
--
ALTER TABLE `app_notices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attention`
--
ALTER TABLE `attention`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bandwidth_logs`
--
ALTER TABLE `bandwidth_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `blocked_ips`
--
ALTER TABLE `blocked_ips`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_ip` (`ip_address`),
  ADD KEY `idx_blocked_until` (`blocked_until`);

--
-- Indexes for table `chat`
--
ALTER TABLE `chat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat_id1` (`chat_id1`),
  ADD KEY `chat_id2` (`chat_id2`),
  ADD KEY `chat_status` (`chat_status`);

--
-- Indexes for table `cloudflare_domains`
--
ALTER TABLE `cloudflare_domains`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `conversion_logs`
--
ALTER TABLE `conversion_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `credits_logs`
--
ALTER TABLE `credits_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cronjob_banned_ip`
--
ALTER TABLE `cronjob_banned_ip`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cronjob_logs`
--
ALTER TABLE `cronjob_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deleted_app_logs`
--
ALTER TABLE `deleted_app_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deleted_logs`
--
ALTER TABLE `deleted_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dns`
--
ALTER TABLE `dns`
  ADD PRIMARY KEY (`dns_id`) USING BTREE;

--
-- Indexes for table `download`
--
ALTER TABLE `download`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `duration`
--
ALTER TABLE `duration`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `duration_logs`
--
ALTER TABLE `duration_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `email_campaigns`
--
ALTER TABLE `email_campaigns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status` (`status`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `created_date` (`created_date`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_by` (`created_by`),
  ADD KEY `idx_created_date` (`created_date`);

--
-- Indexes for table `email_campaign_recipients`
--
ALTER TABLE `email_campaign_recipients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `campaign_subscriber` (`campaign_id`,`subscriber_id`),
  ADD KEY `campaign_id` (`campaign_id`),
  ADD KEY `subscriber_id` (`subscriber_id`),
  ADD KEY `status` (`status`),
  ADD KEY `tracking_token` (`tracking_token`);

--
-- Indexes for table `email_subscribers`
--
ALTER TABLE `email_subscribers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `status` (`status`),
  ADD KEY `source` (`source`),
  ADD KEY `subscribed_date` (`subscribed_date`);

--
-- Indexes for table `email_templates`
--
ALTER TABLE `email_templates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `template_type` (`template_type`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `is_active` (`is_active`);

--
-- Indexes for table `freeze_request`
--
ALTER TABLE `freeze_request`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `json_update`
--
ALTER TABLE `json_update`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `limit_logs`
--
ALTER TABLE `limit_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `limit_registration`
--
ALTER TABLE `limit_registration`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD KEY `idx_ip` (`ip`);

--
-- Indexes for table `login_attempts_logs`
--
ALTER TABLE `login_attempts_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `login_banned_ip`
--
ALTER TABLE `login_banned_ip`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nas`
--
ALTER TABLE `nas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nasname` (`nasname`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `page_content`
--
ALTER TABLE `page_content`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_page_name` (`page_name`),
  ADD KEY `idx_section_order` (`section_order`);

--
-- Indexes for table `page_customizations`
--
ALTER TABLE `page_customizations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_page_customization` (`page_name`,`customization_type`),
  ADD KEY `idx_page_name` (`page_name`),
  ADD KEY `idx_customization_type` (`customization_type`);

--
-- Indexes for table `radacct`
--
ALTER TABLE `radacct`
  ADD PRIMARY KEY (`radacctid`),
  ADD UNIQUE KEY `acctuniqueid` (`acctuniqueid`),
  ADD KEY `username` (`username`),
  ADD KEY `framedipaddress` (`framedipaddress`),
  ADD KEY `acctsessionid` (`acctsessionid`),
  ADD KEY `acctsessiontime` (`acctsessiontime`),
  ADD KEY `acctstarttime` (`acctstarttime`),
  ADD KEY `acctstoptime` (`acctstoptime`),
  ADD KEY `nasipaddress` (`nasipaddress`);

--
-- Indexes for table `radcheck`
--
ALTER TABLE `radcheck`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`(32));

--
-- Indexes for table `radgroupcheck`
--
ALTER TABLE `radgroupcheck`
  ADD PRIMARY KEY (`id`),
  ADD KEY `groupname` (`groupname`(32));

--
-- Indexes for table `radgroupreply`
--
ALTER TABLE `radgroupreply`
  ADD PRIMARY KEY (`id`),
  ADD KEY `groupname` (`groupname`(32));

--
-- Indexes for table `radpostauth`
--
ALTER TABLE `radpostauth`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `radreply`
--
ALTER TABLE `radreply`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`(32));

--
-- Indexes for table `radusergroup`
--
ALTER TABLE `radusergroup`
  ADD KEY `username` (`username`(32));

--
-- Indexes for table `recovery_logs`
--
ALTER TABLE `recovery_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reloadduration_logs`
--
ALTER TABLE `reloadduration_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reseller_applications`
--
ALTER TABLE `reseller_applications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `status` (`status`),
  ADD KEY `applied_date` (`applied_date`);

--
-- Indexes for table `reseller_settings`
--
ALTER TABLE `reseller_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_name` (`setting_name`);

--
-- Indexes for table `security_logs`
--
ALTER TABLE `security_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ip_timestamp` (`ip_address`,`timestamp`),
  ADD KEY `idx_event_type` (`event_type`),
  ADD KEY `idx_timestamp` (`timestamp`);

--
-- Indexes for table `security_settings`
--
ALTER TABLE `security_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_setting` (`setting_name`);

--
-- Indexes for table `server_list`
--
ALTER TABLE `server_list`
  ADD PRIMARY KEY (`server_id`),
  ADD KEY `idx_server_ip` (`server_ip`),
  ADD KEY `idx_proto` (`proto`);

--
-- Indexes for table `site_options`
--
ALTER TABLE `site_options`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `slider_images`
--
ALTER TABLE `slider_images`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subscriber_config`
--
ALTER TABLE `subscriber_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subscriber_id` (`subscriber_id`),
  ADD KEY `email_frequency` (`email_frequency`),
  ADD KEY `email_format` (`email_format`);

--
-- Indexes for table `support_message`
--
ALTER TABLE `support_message`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `support_ticket`
--
ALTER TABLE `support_ticket`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `suspension_logs`
--
ALTER TABLE `suspension_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `suspension_recovery_logs`
--
ALTER TABLE `suspension_recovery_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `username_logs`
--
ALTER TABLE `username_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `users_delete`
--
ALTER TABLE `users_delete`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_profile`
--
ALTER TABLE `users_profile`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code_name` (`code_name`);

--
-- Indexes for table `voucher_logs`
--
ALTER TABLE `voucher_logs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code_name` (`code_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `ads_api_logs`
--
ALTER TABLE `ads_api_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ads_apps`
--
ALTER TABLE `ads_apps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `ads_revenue`
--
ALTER TABLE `ads_revenue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `anti_ddos`
--
ALTER TABLE `anti_ddos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `application`
--
ALTER TABLE `application`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `applications`
--
ALTER TABLE `applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `app_notices`
--
ALTER TABLE `app_notices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `attention`
--
ALTER TABLE `attention`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bandwidth_logs`
--
ALTER TABLE `bandwidth_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blocked_ips`
--
ALTER TABLE `blocked_ips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat`
--
ALTER TABLE `chat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cloudflare_domains`
--
ALTER TABLE `cloudflare_domains`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `conversion_logs`
--
ALTER TABLE `conversion_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `credits_logs`
--
ALTER TABLE `credits_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `cronjob_banned_ip`
--
ALTER TABLE `cronjob_banned_ip`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cronjob_logs`
--
ALTER TABLE `cronjob_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deleted_app_logs`
--
ALTER TABLE `deleted_app_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `deleted_logs`
--
ALTER TABLE `deleted_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dns`
--
ALTER TABLE `dns`
  MODIFY `dns_id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65032;

--
-- AUTO_INCREMENT for table `download`
--
ALTER TABLE `download`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `duration`
--
ALTER TABLE `duration`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `duration_logs`
--
ALTER TABLE `duration_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `email_campaigns`
--
ALTER TABLE `email_campaigns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `email_campaign_recipients`
--
ALTER TABLE `email_campaign_recipients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `email_subscribers`
--
ALTER TABLE `email_subscribers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `email_templates`
--
ALTER TABLE `email_templates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `freeze_request`
--
ALTER TABLE `freeze_request`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `json_update`
--
ALTER TABLE `json_update`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `limit_logs`
--
ALTER TABLE `limit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `limit_registration`
--
ALTER TABLE `limit_registration`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login_attempts_logs`
--
ALTER TABLE `login_attempts_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=321;

--
-- AUTO_INCREMENT for table `login_banned_ip`
--
ALTER TABLE `login_banned_ip`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=196;

--
-- AUTO_INCREMENT for table `nas`
--
ALTER TABLE `nas`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `page_content`
--
ALTER TABLE `page_content`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `page_customizations`
--
ALTER TABLE `page_customizations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `radacct`
--
ALTER TABLE `radacct`
  MODIFY `radacctid` bigint(21) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radcheck`
--
ALTER TABLE `radcheck`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `radgroupcheck`
--
ALTER TABLE `radgroupcheck`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radgroupreply`
--
ALTER TABLE `radgroupreply`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radpostauth`
--
ALTER TABLE `radpostauth`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radreply`
--
ALTER TABLE `radreply`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recovery_logs`
--
ALTER TABLE `recovery_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reloadduration_logs`
--
ALTER TABLE `reloadduration_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reseller_applications`
--
ALTER TABLE `reseller_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `reseller_settings`
--
ALTER TABLE `reseller_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `security_logs`
--
ALTER TABLE `security_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `security_settings`
--
ALTER TABLE `security_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `server_list`
--
ALTER TABLE `server_list`
  MODIFY `server_id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `site_options`
--
ALTER TABLE `site_options`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `slider_images`
--
ALTER TABLE `slider_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `subscriber_config`
--
ALTER TABLE `subscriber_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_message`
--
ALTER TABLE `support_message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_ticket`
--
ALTER TABLE `support_ticket`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suspension_logs`
--
ALTER TABLE `suspension_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `suspension_recovery_logs`
--
ALTER TABLE `suspension_recovery_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `username_logs`
--
ALTER TABLE `username_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1061;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58344;

--
-- AUTO_INCREMENT for table `users_delete`
--
ALTER TABLE `users_delete`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_profile`
--
ALTER TABLE `users_profile`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15353;

--
-- AUTO_INCREMENT for table `vouchers`
--
ALTER TABLE `vouchers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6023;

--
-- AUTO_INCREMENT for table `voucher_logs`
--
ALTER TABLE `voucher_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=226;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ads_revenue`
--
ALTER TABLE `ads_revenue`
  ADD CONSTRAINT `ads_revenue_ibfk_1` FOREIGN KEY (`app_id`) REFERENCES `ads_apps` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
