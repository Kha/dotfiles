#!/usr/bin/python2
# coding=utf8
#
# Tollere Uhrzeiten - wie zum Beispiel
# 5 vor [Ü] Algebra
# [Ü] Algebra
# 5 nach [Ü] Algebra
# 10 nach [Ü] Algebra
# ...
# 30 nach [Ü] Algebra
# 5 nach Halb 9
# 5 vor Dreiviertel 9

GOOGLE_EMAIL = 'hereyougo'
GOOGLE_PASSWORD = 'admin123'


try:
    from xml.etree import ElementTree # for Python 2.5 users
except ImportError:
    from elementtree import ElementTree
import gdata.calendar.service
import gdata.service
import atom.service
import gdata.calendar
import atom
import getopt
import sys
import string
import time
import iso8601
import urllib2
import functools
import tempfile
import os
import pickle

from datetime import datetime, timedelta
from bisect import bisect_left

@functools.total_ordering
class Event(object):
    def __init__(self, time, name):
        self.time = time
        self.name = name

    def __repr__(self):
        return "Event({0}, {1})".format(self.time, self.name)

    def __lt__(self, other):
        return self.time < other.time

def google_events(date):
    calendar_service = gdata.calendar.service.CalendarService()
    calendar_service.email = GOOGLE_EMAIL
    calendar_service.password = GOOGLE_PASSWORD
    calendar_service.source = 'uhrzeit.py'
    calendar_service.ProgrammaticLogin()

    for cal in calendar_service.GetAllCalendarsFeed().entry:
        # 'http://www.google.com/calendar/feeds/default/allcalendars/full/your-calendar%40group.calendar.google.com' -> 'your-calendar@group.calendar.google.com'
        id = urllib2.unquote(cal.id.text.split('/')[-1])

        query = gdata.calendar.service.CalendarEventQuery(id)
        query.singleevents = 'true'
        query.orderby = 'starttime'
        query.start_min = (date - timedelta(days=1)).isoformat() + "Z"
        query.start_max = (date + timedelta(days=2)).isoformat() + "Z"

        for event in calendar_service.CalendarQuery(query).entry:
            yield Event(iso8601.parse_date(event.when[0].start_time).replace(tzinfo=None), event.title.text)

def cached_google_events(date):
    path = os.path.join(tempfile.gettempdir(), 'uhrzeit-cache')
    try:
        with open(path, 'rb') as f:
            date2, events = pickle.load(f)
        if date == date2: return events
    except (IOError, EOFError):
        pass

    events = list(google_events(date))
    with open(path, 'wb') as f:
        pickle.dump((date, events), f)
    return events

quarter_names = [("{0} Uhr", 0), ("Viertel {0}", 1), ("Halb {0}", 1), ("Dreiviertel {0}", 1)]

def halfday(hour):
    return (hour + 11) % 12 + 1

def quarter_event(t):
    q = t.minute // 15
    format, delta = quarter_names[q]
    return Event(t.replace(minute=q*15), format.format(halfday(t.hour + delta)))

def nearest_event(t, events):
    if not events:
        return None

    i = bisect_left([ev.time for ev in events], t)
    if i == len(events) or i > 0 and t - events[i-1].time < events[i].time - t: i -= 1
    return events[i]

def preetyprint(t):
    ev = nearest_event(t, sorted(cached_google_events(t.date())))
    if ev is None or abs(ev.time - t) > timedelta(minutes=30):
        ev = nearest_event(t, [quarter_event(t + timedelta(minutes=i*15)) for i in range(5)])
    delta_min = int((t - ev.time).total_seconds()) // 60

    words = [ev.name]
    if delta_min != 0:
        words[:0] = [str(abs(delta_min)), "nach" if delta_min > 0 else "vor"]
    return " ".join(words)

def generic_range(start, stop, step):
    while start < stop:
        yield start
        start += step

print preetyprint(datetime.now())
# for t in generic_range(datetime(year=2013, month=1, day=18, hour=8), datetime(year=2013, month=1, day=18, hour=12), timedelta(minutes=5)):
#     print preetyprint(t)
