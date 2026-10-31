//! Civil dates for the calendar: no time zone, no dependency.
//!
//! Day counting uses Howard Hinnant's `days_from_civil` algorithm
//! (proleptic Gregorian calendar).

use std::fmt;

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct Date {
    pub year: i32,
    pub month: u32,
    pub day: u32,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Month {
    pub year: i32,
    pub month: u32,
}

/// One cell of a month grid.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Day {
    pub date: Date,
    /// The date belongs to the previous or the next month.
    pub outside: bool,
}

const MONTHS: [&str; 12] = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
];

pub const WEEKDAYS: [&str; 7] = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

impl Date {
    /// Parses `YYYY-MM-DD`. Returns `None` for anything else, or a day the
    /// month does not have.
    pub fn parse(text: &str) -> Option<Date> {
        let mut parts = text.splitn(3, '-');
        let year = parts.next()?.parse().ok()?;
        let month = parts.next()?.parse().ok()?;
        let day = parts.next()?.parse().ok()?;
        ((1..=12).contains(&month) && day >= 1 && day <= days_in_month(year, month))
            .then_some(Date { year, month, day })
    }

    fn days(self) -> i64 {
        let y = i64::from(self.year) - i64::from(self.month <= 2);
        let era = y.div_euclid(400);
        let yoe = y - era * 400;
        let m = i64::from(self.month);
        let doy = (153 * (if m > 2 { m - 3 } else { m + 9 }) + 2) / 5 + i64::from(self.day) - 1;
        let doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
        era * 146_097 + doe - 719_468
    }

    fn from_days(days: i64) -> Date {
        let z = days + 719_468;
        let era = z.div_euclid(146_097);
        let doe = z - era * 146_097;
        let yoe = (doe - doe / 1460 + doe / 36_524 - doe / 146_096) / 365;
        let doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
        let mp = (5 * doy + 2) / 153;
        let day = (doy - (153 * mp + 2) / 5 + 1) as u32;
        let month = if mp < 10 { mp + 3 } else { mp - 9 } as u32;
        let year = (yoe + era * 400 + i64::from(month <= 2)) as i32;
        Date { year, month, day }
    }

    pub fn add_days(self, n: i64) -> Date {
        Date::from_days(self.days() + n)
    }

    /// 0 is Sunday.
    pub fn weekday(self) -> u32 {
        (self.days() + 4).rem_euclid(7) as u32
    }

    /// `Oct 31, 2026`
    pub fn human(self) -> String {
        format!(
            "{} {}, {}",
            &MONTHS[self.month as usize - 1][..3],
            self.day,
            self.year
        )
    }
}

impl fmt::Display for Date {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:04}-{:02}-{:02}", self.year, self.month, self.day)
    }
}

pub fn days_in_month(year: i32, month: u32) -> u32 {
    match month {
        2 if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 => 29,
        2 => 28,
        4 | 6 | 9 | 11 => 30,
        _ => 31,
    }
}

impl Month {
    /// Parses `YYYY-MM`.
    pub fn parse(text: &str) -> Option<Month> {
        let (year, month) = text.split_once('-')?;
        let month = month.parse().ok()?;
        (1..=12).contains(&month).then_some(Month {
            year: year.parse().ok()?,
            month,
        })
    }

    pub fn of(date: Date) -> Month {
        Month {
            year: date.year,
            month: date.month,
        }
    }

    pub fn previous(self) -> Month {
        if self.month == 1 {
            Month {
                year: self.year - 1,
                month: 12,
            }
        } else {
            Month {
                month: self.month - 1,
                ..self
            }
        }
    }

    pub fn next(self) -> Month {
        if self.month == 12 {
            Month {
                year: self.year + 1,
                month: 1,
            }
        } else {
            Month {
                month: self.month + 1,
                ..self
            }
        }
    }

    /// `October 2026`
    pub fn title(self) -> String {
        format!("{} {}", MONTHS[self.month as usize - 1], self.year)
    }

    /// Weeks from Sunday to Saturday, with the days of the next and previous
    /// months that complete the first and last week.
    pub fn weeks(self) -> Vec<[Day; 7]> {
        let first = Date {
            year: self.year,
            month: self.month,
            day: 1,
        };
        let start = first.add_days(-i64::from(first.weekday()));
        let last = first.add_days(i64::from(days_in_month(self.year, self.month)) - 1);
        let mut weeks = Vec::new();
        let mut day = start;
        while day <= last {
            weeks.push(std::array::from_fn(|i| {
                let date = day.add_days(i as i64);
                Day {
                    date,
                    outside: date.month != self.month,
                }
            }));
            day = day.add_days(7);
        }
        weeks
    }
}

impl fmt::Display for Month {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:04}-{:02}", self.year, self.month)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn halloween_2026_is_a_saturday() {
        assert_eq!(Date::parse("2026-10-31").unwrap().weekday(), 6);
    }

    #[test]
    fn day_counting_round_trips_across_leap_years() {
        let start = Date::parse("2023-12-25").unwrap();
        for n in 0..2000 {
            let date = start.add_days(n);
            assert_eq!(Date::parse(&date.to_string()), Some(date));
        }
        assert_eq!(
            Date::parse("2024-02-28").unwrap().add_days(1).to_string(),
            "2024-02-29"
        );
    }

    #[test]
    fn a_month_grid_starts_on_sunday_and_holds_every_day() {
        let weeks = Month::parse("2026-02").unwrap().weeks();
        assert_eq!(weeks[0][0].date.to_string(), "2026-02-01");
        let inside = weeks.iter().flatten().filter(|d| !d.outside).count();
        assert_eq!(inside, 28);
    }

    #[test]
    fn parse_refuses_a_day_the_month_does_not_have() {
        assert_eq!(Date::parse("2026-02-30"), None);
        assert_eq!(Month::parse("2026-13"), None);
    }
}
