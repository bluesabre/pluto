require 'minitest/autorun'
require 'rexml/document'

require_relative './tmpl.rb'



class TestMerge < MiniTest::Test

  Site     = Struct.new( :name, :owner_name, :date_822, :channels )
  Channel  = Struct.new( :name, :url, :channel_link )

  def sample1
       Site.new( 'OpenStreetMap Blogs',
                 'OpenStreetMap',
                  Date.new( 2020, 2, 7 ).rfc2822,
                 [Channel.new( 'Shaun McDonald',
                               'http://blog.shaunmcdonald.me.uk/feed/',
                               'http://blog.shaunmcdonald.me.uk/' ),
                  Channel.new( 'Mapbox',
                               'https://blog.mapbox.com/feed/tagged/openstreetmap/',
                               'https://blog.mapbox.com/' ),
                  Channel.new( 'Mapillary',
                               'https://blog.mapillary.com/rss.xml',
                               'https://blog.mapillary.com' ),
                  Channel.new( 'Richard Fairhurst',
                               'http://blog.systemed.net/rss',
                               'http://blog.systemed.net/' )]
                )
  end

  def test_merge
     site = sample1
     pp site

     xml      = File.open( "./opml.xml",      "r:utf-8" ).read
     template = File.open( "./opml.xml.tmpl", "r:utf-8" ).read

     t = HtmlTemplate.new( template )

     assert_equal prettify_xml( xml ),
                  prettify_xml( t.render( name:       site.name,
                                          owner_name: site.owner_name,
                                          date_822:   site.date_822,
                                          channels:   site.channels ))
  end


  def test_convert
    text     = File.open( "./opml.xml.erb", "r:utf-8" ).read
    template = File.open( "./opml.xml.tmpl", "r:utf-8" ).read

    t = HtmlTemplate.new( template )

    assert_equal text, t.text
  end

=begin
<!-- students.tmpl -->
<TMPL_LOOP NAME=STUDENT>
   <p>
   Name: <TMPL_VAR NAME=NAME><br/>
   GPA: <TMPL_VAR NAME=GPA>
   </p>
</TMPL_LOOP>

# students.pl
my $template = HTML::Template->new(filename => 'students.tmpl');

$template->param(
   STUDENT => [
      { NAME => 'Bluto Blutarsky', GPA => '0.0' },
      { NAME => 'Tracey Flick'   , GPA => '4.0' },
   ]
);
print $template->output;
=end

  Student = Struct.new( :name, :gpa )

  def test_students_example

    tmpl =<<TXT
    <TMPL_LOOP students>
       <p>
       Name: <TMPL_VAR name><br/>
       GPA: <TMPL_VAR gpa>
       </p>
    </TMPL_LOOP>
TXT

    t = HtmlTemplate.new( tmpl )
    puts t.text
    puts "---"
    puts t.render( students: [ Student.new( 'Bluto Blutarsky', 0.0 ),
                               Student.new( 'Tracey Flick',    4.0 ) ])


    assert true   # assume it's alright if we get here
  end




  #####################
  #    xml helper
  def prettify_xml( xml )
      d = REXML::Document.new( xml )

      formatter = REXML::Formatters::Pretty.new( 2 )  # indent=2
      formatter.compact = true # This is the magic line that does what you need!
      pretty_xml = formatter.write( d.root, "" )  # todo/checl: what's 2nd arg used for ??
      pretty_xml
  end
end

