# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class Incognito
  include FullNameSplitter
  attr_accessor :first_name, :middle_name, :last_name
end

describe Incognito do
  describe "#full_name=" do

    #
    # Environment
    #

    subject { Incognito.new }

    def gum(first, middle, last)
      "[#{first}] + [#{middle}] + [#{last}]"
    end



    #
    # Examples
    #
    # "First Middle Last"             => ["First",    "Middle",   "Last",              , "Prefix", "Suffix", "Middle Initial"]

    {
      "John Smith"                    => ["John",     nil,        "Smith"              ,nil   ,nil, nil   ],
      "Kevin Smith II"                => ["Kevin",    nil,        "Smith"              ,nil,   "II", nil  ],
      "Kevin Smith XIX"               => ["Kevin",    nil,        "Smith"              ,nil,   "XIX", nil  ],
      "Kevin J. O'Connor"             => ["Kevin",    "J.",      "O'Connor"            ,nil   ,nil, 'J'   ],
      "Gabriel Van Helsing"           => ["Gabriel",  nil,      "Van Helsing"          ,nil   ,nil, nil   ],
      "Pierre de Montesquiou"         => ["Pierre",   nil,      "de Montesquiou"       ,nil   ,nil, nil   ],
      "Charles d'Artagnan"            => ["Charles",  nil,      "d'Artagnan"           ,nil   ,nil, nil   ],
      "Jaazaniah ben Shaphan"         => ["Jaazaniah", nil,     "ben Shaphan"          ,nil   ,nil, nil   ],
      "Noda' bi-Yehudah"              => ["Noda'",    nil,      "bi-Yehudah"           ,nil   ,nil, nil   ],
      "Maria del Carmen Menendez"     => ["Maria",    nil,      "del Carmen Menendez"  ,nil   ,nil, nil   ],
      "Alessandro Del Piero"          => ["Alessandro",  nil,   "Del Piero"            ,nil   ,nil, nil   ],

      "George W Bush"                 => ["George",  "W",     "Bush"                ,nil   ,nil, 'W'   ],
      "George H. W. Bush"             => ["George",  "H. W.", "Bush"                 ,nil   ,nil, 'H'   ],
      "James K. Polk"                 => ["James", "K.",   "Polk"                    ,nil   ,nil, 'K'   ],
      "William Henry Harrison"        => ["William", "Henry", "Harrison"             ,nil   ,nil, 'H'   ],
      "John Quincy Adams"             => ["John", "Quincy",  "Adams"                ,nil   ,nil, 'Q'   ],

      "John Quincy"                   => ["John",     nil,      "Quincy"               ,nil   ,nil, nil   ],
      "George H. W."                  => ["George",   "H. W.",   nil                    ,nil   ,nil, 'H'   ],
      "Van Helsing"                   => [nil,       nil,       "Van Helsing"          ,nil   ,nil, nil   ],
      "d'Artagnan"                    => [nil,       nil,       "d'Artagnan"           ,nil   ,nil, nil   ],
      "O'Connor"                      => [nil,       nil,       "O'Connor"             ,nil   ,nil, nil   ],

      "George"                        => ["George",    nil,     nil                    ,nil   ,nil, nil   ],
      "Kevin J. "                     => ["Kevin",    "J.",   nil                    ,nil   ,nil, 'J'   ],

      "Thomas G. Della Fave"          => ["Thomas",   "G.",   "Della Fave"           ,nil   ,nil, 'G'   ],
      "Anne du Bourg"                 => ["Anne",     nil,      "du Bourg"             ,nil   ,nil, nil   ],

      # German
      "Johann Wolfgang von Goethe"    => ["Johann",  "Wolfgang", "von Goethe"          ,nil   ,nil, 'W'   ],

      # Spanish-speaking countries
      "Juan Martín de la Cruz Gómez"  => ["Juan", "Martín",    "de la Cruz Gómez"     ,nil   ,nil, 'M'   ],
      "Javier Reyes de la Barrera"    => ["Javier", "Reyes",        "de la Barrera"  ,nil   ,nil, 'R'   ],
      "Rosa María Pérez Martínez Vda. de la Cruz" =>
                                         ["Rosa", "María Pérez Martínez",   "Vda. de la Cruz" ,nil ,nil, 'M'],

      # Italian
      "Federica Pellegrini"           => ["Federica",  nil,     "Pellegrini"           ,nil   ,nil, nil   ],
      "Leonardo da Vinci"             => ["Leonardo",  nil,     "da Vinci"             ,nil   ,nil, nil   ],

      # sounds like a fancy medival action movie star pseudonim
      "Alberto Del Sole"              => ["Alberto",   nil,     "Del Sole"             ,nil   ,nil, nil   ],
      # horror movie star pseudonim?
      "Adriano Dello Spavento"        => ["Adriano",   nil,     "Dello Spavento"       ,nil   ,nil, nil   ],
      "Luca Delle Fave"               => ["Luca",      nil,     "Delle Fave"           ,nil   ,nil, nil   ],
      "Francesca Della Valle"         => ["Francesca", nil,     "Della Valle"          ,nil   ,nil, nil   ],
      "Guido Delle Colonne"           => ["Guido",     nil,     "Delle Colonne"        ,nil   ,nil, nil   ],
      "Tomasso D'Arco"                => ["Tomasso",   nil,     "D'Arco"               ,nil   ,nil, nil   ],

      # Dutch
      "Johan de heer Van Kampen"      => ["Johan",    nil,      "de heer Van Kampen"   ,nil   ,nil, nil   ],
      "Han Van De Casteele"           => ["Han",      nil,      "Van De Casteele"      ,nil   ,nil, nil   ],
      "Han Vande Casteele"            => ["Han",      nil,      "Vande Casteele"       ,nil   ,nil, nil   ],

      # Exceptions?
      # the architect Ludwig Mies van der Rohe, from the West German city of Aachen, was originally Ludwig Mies;
      "Ludwig Mies van der Rohe"      => ["Ludwig",    "Mies",     "van der Rohe"    ,nil   ,nil, 'M'   ],

      # If comma is provided then split by comma

      "Smith, John"             => ["John",  nil,  "Smith"              ,nil  ,nil, nil ],
      "Dello Fave Jr., Luca"     => ["Luca",  nil, "Dello Fave",    nil,    "Jr.", nil],


      # Test ignoring unnecessary whitespace
      "\t Ludwig  Mies\t van der Rohe "   => ["Ludwig", "Mies", "van der Rohe"        ,nil   ,nil, 'M'   ],
      #"\t Ludwig  Mies,\t van  der Rohe " => ["Ludwig Mies", nil, "van der Rohe"        ,nil   ,nil   ],
      "\t Ludwig      "                   => ["Ludwig", nil, nil                        ,nil   ,nil, nil   ],
      "  van  helsing "                   => [nil, nil, "van helsing"                   ,nil   ,nil, nil   ],
      #" , van  helsing "                  => [nil, nil, "van helsing"                   ,nil   ,nil   ],
      #"\t Ludwig  Mies,\t van  der Rohe " => ["Ludwig", "Mies", "van der Rohe"        ,nil   ,nil   ],

      # Test for suffixes
      "John Smith phd."                    => ["John",     nil,        "Smith"   , nil,  "phd.", nil  ],
      "Johann Wolfgang von Goethe Jr."    => ["Johann",  "Wolfgang", "von Goethe",  nil, "Jr.", 'W' ],

      # Test for title
      "Sir Francis Bacon"                => ["Francis",    nil,    "Bacon",   "Sir",  nil, nil],
      "Mr Kevin J. O'Connor sr. "        => ["Kevin",    "J.",    "O'Connor",   "Mr",  "sr.", 'J'],

      # Test for middle initial
      "Διογένης Λητώ Πανδώρα"            => ["Διογένης", "Λητώ", "Πανδώρα", nil, nil, 'Λ'],
      'Arthur "Miles" Davis'             => ['Arthur', '"Miles"', 'Davis', nil, nil, 'M']
    }.

    each do |full_name, split_name|
      #it "should split #{full_name} to '#{split_name.first}','#{split_name[1]}' and '#{split_name.last}'" do
      #  subject.full_name = full_name
      #  gum(subject.first_name, subject.middle_name, subject.last_name).should == gum(*split_name)
      #end

      it "should split #{full_name} to '#{split_name.first}' , '#{split_name[1]}' and '#{split_name.last}' when called as module function" do
        FullNameSplitter.split(full_name).should == split_name.first(3)

        name = FullNameSplitter.parse(full_name)
        [name[:first_name], name[:middle_name], name[:last_name], name[:prefix], name[:suffix], name[:middle_initial]].should == split_name
      end

    end
  end
end
