-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Find all crime scene information
SELECT *
FROM crime_scene_reports
WHERE year = 2025
AND month = 7 AND day = 28
AND street = 'Humphrey Street';

-- Theft took place at 10:15am
-- witnesses mention the bakery

-- Read witness interview
SELECT *
FROM interviews
WHERE year = 2025
AND month = 7
AND day = 28

--Ruth
--interviews mentions the thief get into a car in the bakery parking lot and drive away.
--Suggests finding security footage from the bakery parking lot
--look for cars that left the parking lot in that time frame

--Eugene
--He recognized him
--Emma's bakery
--Before he was at the bakery he saw the thief withdraw money at the ATM on Leggett Street

--Raymond
--The theif called someone for less than a minute after leaving the bakery.
--Said he was planning to take the earliest flight out of Fiftyville tomorrow.
--He then asked the other person to purchase the flight ticket.

--Find cars leaving the bakery
SELECT license_plate
FROM bakery_security_logs
WHERE year = 2025
AND month = 7
AND day = 28
AND hour = 10
AND minute BETWEEN 15 AND 25
AND activity = 'exit';

--5P2BI95, 94KL13X, 6P58WS2, 4328GD8, G412CB7, L93JTIZ, 322W7JE, 0NTHK55

--Turn license plates into PEOPLE
SELECT name, license_plate
FROM people
WHERE license_plate IN (
    '5P2BI95', '94KL13X', '6P58WS2', '4328GD8',
    'G412CB7', 'L93JTIZ', '322W7JE', '0NTHK55'
);

--| Vanessa | 5P2BI95       |
--| Barry   | 6P58WS2       |
--| Iman    | L93JTIZ       |
--| Sofia   | G412CB7       |
--| Luca    | 4328GD8       |
--| Diana   | 322W7JE       |
--| Kelsey  | 0NTHK55       |
--| Bruce   | 94KL13X       |

--Who used the ATM?
SELECT DISTINCT people.name
FROM people
JOIN bank_accounts
ON people.id = bank_accounts.person_id
JOIN atm_transactions
ON bank_accounts.account_number = atm_transactions.account_number
WHERE atm_transactions.year = 2025
AND atm_transactions.month = 7
AND atm_transactions.day = 28
AND atm_transactions.atm_location = 'Leggett Street'
AND atm_transactions.transaction_type = 'withdraw';

--| Luca    |
--| Kenny   |
--| Taylor  |
--| Bruce   |
--| Brooke  |
--| Iman    |
--| Benista |
--| Diana   |

--overlap = Luca, Bruce, Iman, Diana

--Phone call clue
--The thief made a phone call that lasted less than 60 seconds
SELECT DISTINCT people.name
FROM people
JOIN phone_calls
ON people.phone_number = phone_calls.caller
WHERE phone_calls.year = 2025
AND phone_calls.month = 7
AND phone_calls.day = 28
AND phone_calls.duration < 60;

--| Sofia   |
--| Kelsey  |
--| Bruce   |
--| Taylor  |
--| Diana   |
--| Carina  |
--| Kenny   |
--| Benista |

--overlap = Bruce, Diana

--Find the earliest flight from the next day
SELECT *
FROM flights
WHERE year = 2025
AND month = 7
AND day = 29
ORDER BY hour, minute
LIMIT 1;

--id = 36

SELECT people.name
FROM people
JOIN passengers
ON people.passport_number = passengers.passport_number
WHERE passengers.flight_id = 36;

--| Doris  |
--| Sofia  |
--| Bruce  |
--| Edward |
--| Kelsey |
--| Taylor |
--| Kenny  |
--| Luca   |

--thief = Bruce

--Where did they escape?
SELECT city
FROM airports
JOIN flights
ON airports.id = flights.destination_airport_id
WHERE flights.id = 36;

--They escaped to New York City

--Who is the accomplice?
--Find phone number
SELECT phone_number
FROM people
WHERE name = 'Bruce';

--(367) 555-5533

--Find recieving phone number
SELECT receiver
FROM phone_calls
WHERE caller = '(367) 555-5533'
AND year = 2025
AND month = 7
AND day = 28
AND duration < 60;

--reciever = (375) 555-8161

--Find name of reciever
SELECT name
FROM people
WHERE phone_number = '(375) 555-8161';

--Accomplice = Robin


