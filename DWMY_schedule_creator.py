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
print (f"=======================================================================")
print (f"= This script will generate daily schedule for given month.           =")
print (f"= Exported .txt file with schedule will be saved to Downloads folder. =")
print (f"=======================================================================")
print (f"")
year, month = map(int, input("Enter the year and month (YYYY MM): ").split())


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

# TODO: incorporate all/as-much-as-possible time-sensitive tasks directly in DR list
# TODO: ^ call as function from DR print list, but keed separated to WEEK-lies/... section in code
	
	############
	# DAY-lies #
	############
# TODO: rework with basic morning (&evening? &during_day?) routine
	# not-work-day schedule
	# print(f"05:00  wake-up", w_b, bat)
	# print(f"weight, prep_d (c, t, vw(vit+col+cr), 1.5l wb)")
	# print(f"[c/t,vw] zt - ms, (zenaf
	# print(f"z2 - mmed, DP&Q check")
	# print(f"bed tu, bat, tb, wght")
	# print(f"bb (hbb/cardio alternate) + [w]")
	# print(f"c_med (cl, ret, pa_succ, fu_succ, po_aff, cl)")
	# print(f"c_sho (+phcu), ec, ncl, deo, cr")
	# print(f"ChE_duct, ice_p")
	# print(f"|| work/DTD block + [w]; stretch ||")
	# print(f"11:00  [w&lunch] + soc/quiet, tb/chg")
	# print(f"powernap (10-30min)")
	# print(f"|| work/DTD block + [w]; stretch ||")
	# print(f"14:00  [prot/(de)c/t+snack/protBar], tb/chg")
	# print(f"|| work/DTD block + [w]; stretch ||")
	# print(f"17:00  [w&din] + soc/tv, tb/chg")
	# print(f"|| relax/DTD block + [finish_wb]; sg ||")
	# print(f"mmed, bat, tb, deo")
	# print(f"charge mp, adb + sleep")
	# print(f"======")

	
	#############
	# WEEK-lies #
	#############
	# EGSfg PC&Android
	if day_name == "Thursday":
		print(f"'EGS free games PC+Android (17:00+)")

	# clean office space & peripherals // currently postponed
	if day_name == "Friday":
		print(f"'office space & peripherals cleaning")
		print(f"^get&note info about next week's shifts")

	# sunday cleaning (personal room/office & body)
	if day_name == "Sunday":
		print(f"'fast flat & my_office cleaning")
		print(f"'fbhcu, wh bath/shower, nc, ec, fbcr")


	##############
	# MONTH-lies #
	##############
	# UEfreebies (1st Thursday after 7th of each month)
	if day_name == "Thursday" and (6 < int(date[:2]) < 14):
		print("'UE monthly freebies")

	# cashflow payments
	if int(date[:2]) == 20:
		print(f"^cashflow payments")

	# 3rd last day of the month tasks
	if int(date[:2]) == num_days-2:
		print(f"'big flat tu")
		print(f"	dust, mop/vacuum, trash, ...")
		print(f"'big pc&peripherals cleaning")
		print(f"	displays, keyboards, mice, gamepads, ...")

	# 2nd last day of the month tasks
	if int(date[:2]) == num_days-1:
		print(f"%R&R")

	# last day of the month tasks
	if int(date[:2]) == num_days:
		print(f"%bb progress")
		print(f"	weighing; photos before training")
		print(f"	training - check exercises progress")
		print(f"	photos after training; photos save & rip")
		print(f"'review big quests/projects & prep new schedule")
		print(f"	DR, Habits, BB, FF, ...")


	#############
	# YEAR-lies #
	#############
	# best-of last year stuff check & misc (2nd/3rd saturday of january; after 14th)
	if month == 1 and day_name == "Saturday" and (14 < int(date[:2]) < 23):
		print(f"'check on YT&/Google")
		print(f"	best pc games of ...")
		print(f"	best tv shows of ...")
		print(f"	best movies of ...")
		print(f"	best of year ...")
		print(f"('Predplatenka Telekom -- refill credit")
		print(f"('check/change clothes in car trunk")

	# mid-year misc (2nd/3rd saturday of july; after 14th)
	if month == 1 and day_name == "Saturday" and (14 < int(date[:2]) < 23):
		print(f"('Predplatenka Telekom -- refill credit")

	# end of the year personal stuff recap & prep for new year (31.12.)
	if int(date[:2]) == 31 and month == 12:
		print(f"'check & update big PlanX quests")
		print(f"'med - personal yearly retrospective session")

	
	# spacing
	print(f"")
	print(f"")
	print(f"")