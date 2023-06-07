import calendar
import os
import sys


# generate list of all dates in given month
def generate_month_schedule(year, month):
	list = []
	for day in range(1, num_days + 1):
		date = f"{day:02d}.{calendar.month_abbr[month].lower()}"
		day_name = calendar.day_name[calendar.weekday(year, month, day)]
		list.append((date, day_name))
	return list

# User input for year and month
# v1: no semi-weekly (or similar) tasks in schedule
print (f"=======================================================================")
print (f"= This script will generate daily schedule for given month.           =")
print (f"= Exported .txt file with schedule will be saved to Downloads folder. =")
print (f"=======================================================================")
print (f"")
year, month = map(int, input("Enter the year and month (YYYY MM): ").split())

# v2: semi-weekly massage appointments currently postponed
# User input for year and month and massage schedule
# year, month, massage_next_week = map(int, input("Enter the year, month and wheather there is massage planned for next week (YYYY MM 0/1): ").split())


# export print commands to external .txt file
class PrintToFile:
	def __init__(self, filename):
		self.file = open(filename, "w")

	def write(self, text):
		self.file.write(text)

	def flush(self):
		self.file.flush()

downloads_folder_path = os.path.expanduser("~/Downloads") # get the path to the Downloads folder
file_name = str(year) + "_" + str("{:02d}".format(month)) + "_monthly_schedule.txt" # construct whole file name (with month's name)
output_file_path = os.path.join(downloads_folder_path, file_name) # construct the output file path
sys.stdout = PrintToFile(output_file_path) # redirect sys.stdout to write to an external file


# Generating the month schedule
print("====================================" + "=" * len(calendar.month_name[month]))
print(f"Printing monthly schedule for {calendar.month_name[month].lower()} {year}:")
print("====================================" + "=" * len(calendar.month_name[month]))
print(f"")

_, num_days = calendar.monthrange(year, month)
list = generate_month_schedule(year, month)


# adding activities to the list
for date, day_name in list:
	print(f"/// {date} - {day_name} ///")

	#############
	# WEEK-lies #
	#############
	# 17:00 massage (every other week) // currently postponed
	# if day_name == "Thursday" and massage_next_week == 1:
	#     print(f"* 17:00 massage")
	#     print(f"===")
	#     massage_next_week = 0
	# elif day_name == "Thursday":
	#     massage_next_week = 1

	# EGSfg
	if day_name == "Thursday":
		print(f"* EGS free games (17:00+)")

	# clean office space & peripherals
	if day_name == "Friday":
		print(f"* office space & peripherals cleaning")

	# sunday cleaning (personal room/office & body)
	if day_name == "Sunday":
		print(f"* personal room/office cleaning")
		print(f"	vacuum, dust, peripherals, trash out")
		print(f"* fbhcu, wh bath, nc, ec, fbcr")


	##############
	# MONTH-lies #
	##############
	# invoice
	if int(date[:2]) == 1:
		print(f"* create & send invoice")

	# UEfreebies (1st Thursday after 7th of each month)
	if day_name == "Thursday" and (6 < int(date[:2]) < 14):
		print("* UE monthly freebies")

	# cashflow payments
	if int(date[:2]) == 15:
		print(f"* cashflow payments")

	# 3rd last day of the month tasks
	if int(date[:2]) == num_days-2:
		print(f"* big flat cleaning")
		print(f"	vacuum, dust, ...")
		print(f"* big pc&peripherals cleaning")
		print(f"	displays, keyboards, mice, gamepads, pc fans, ...")

	# 2nd last day of the month tasks
	if int(date[:2]) == num_days-1:
		print(f"* relax & regeneration")

	# last day of the month tasks
	if int(date[:2]) == num_days:
		print(f"* bb progress")
		print(f"	weighing; photos before training")
		print(f"	training - check exercises progress")
		print(f"	photos after training; photos save & rip")
		print(f"* review big quests/projects & prep calendar for next month")
		print(f"	Habits, BB, FF")
		print(f"	Plan - X/D/W/M")


	#############
	# YEAR-lies #
	#############
	# best-of last year stuff check & misc (2nd saturday of january; after 15th)
	if month == 1 and day_name == "Saturday" and (15 < int(date[:2]) < 23):
		print(f"* check on YT&/Google")
		print(f"	best pc games of ...")
		print(f"	best tv shows of ...")
		print(f"	best movies of ...")
		print(f"	best of year ...")
		print(f"(* 2nd SIM -- refill credit")

	# end of the year personal stuff recap & prep for new year (31.12.)
	if int(date[:2]) == 31 and month == 12:
		print(f"* check & update yearly quests")
		print(f"	Plan - 0 - X/Y")
		print(f"	personal yearly retrospective session")


	############
	# DAY-lies #
	############
	print(f"=== DR ===")
	print(f"06:00  wake-up")
	print(f"w_boil, bat, prep drinks (c/t(+cr), vw(vit+col(+cr)), 1.5lwb)")
	print(f"[c/t, vw] ms, mmed, DP&Q check")
	print(f"bed tu, bat, tb")
	print(f"bb (hbb/cardio alternate)")
	print(f"c_sho (+hcu), ec, nc, deo, cr")
	print(f"cool_med (clear, retro, past succ, fut succ, pos aff, clear)")
	print(f"|| work/DTD block + [w]; stretch ||")
	print(f"12:00  [lunch] + soc/quiet, tb/chg")
	print(f"powernap (10-30min)")
	print(f"|| work/DTD block + [w]; stretch ||")
	print(f"15:00  [prot/(de)c+snack/protBar], tb/chg")
	print(f"|| work/DTD block + [w]; stretch ||")
	print(f"18:00  [din] + soc/tv, tb/chg")
	print(f"|| relax/DTD block + [wb finish]; sg ||")
	print(f"mmed, bat, tb, deo")
	print(f"charge mp, audiob + sleep")
	print(f"==========")
	print(f"")
	print(f"")