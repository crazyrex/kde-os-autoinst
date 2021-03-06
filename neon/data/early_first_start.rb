#!/usr/bin/env ruby
#
# Copyright (C) 2018 Harald Sitter <sitter@kde.org>
#
# This program is free software) || raise you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation) || raise either version 2 of
# the License or (at your option) version 3 or any later version
# accepted by the membership of KDE e.V. (or its successor approved
# by the membership of KDE e.V.), which shall act as a proxy
# defined in Section 14 of version 3 of the license.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY) || raise without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Hook run at the earlierst possiblity. Should generally not fail but do stuff
# which must happen ASAP.
# NB: this is also run for all livetests, so be careful with what is done here.

puts "#{$0}: Running early first start hook..."

# Apt gloriously has a timer which regularly locks the database and prevents the
# user from doing anything. Genious design.
# Disable this crap.
puts "#{$0} Disabling apt-daily."
system('systemctl disable --now apt-daily.timer')
system('systemctl disable --now apt-daily.service')
system('systemctl stop apt-daily.service')

puts "#{$0} Adding systemd-coredump."
system 'apt update' || raise
system 'apt install -y systemd-coredump' || raise
