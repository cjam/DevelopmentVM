require 'spec_helper_system'

describe 'deprecation warnings' do

  shared_examples 'has_warning'do |pp, w|
    context puppet_apply(pp) do
      its(:stderr) { should =~ /#{Regexp.escape(w)}/m }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should =~ /#{Regexp.escape(w)}/m }
      its(:exit_code) { should be_zero }
    end
  end

  context 'concat gnu parameter' do
    pp = <<-EOS
      concat { '/tmp/concat/file':
        gnu => 'foo',
      }
      concat::fragment { 'foo':
        target => '/tmp/concat/file',
      }
    EOS
    w = 'The $gnu parameter to concat is deprecated and has no effect'

    it_behaves_like 'has_warning', pp, w
  end

  context 'concat::fragment mode parameter' do
    pp = <<-EOS
      concat { '/tmp/concat/file': }
      concat::fragment { 'foo':
        target => '/tmp/concat/file',
        mode   => 'bar',
      }
    EOS
    w = 'The $mode parameter to concat::fragment is deprecated and has no effect'

    it_behaves_like 'has_warning', pp, w
  end

  context 'concat::fragment owner parameter' do
    pp = <<-EOS
      concat { '/tmp/concat/file': }
      concat::fragment { 'foo':
        target => '/tmp/concat/file',
        owner  => 'bar',
      }
    EOS
    w = 'The $owner parameter to concat::fragment is deprecated and has no effect'

    it_behaves_like 'has_warning', pp, w
  end

  context 'concat::fragment group parameter' do
    pp = <<-EOS
      concat { '/tmp/concat/file': }
      concat::fragment { 'foo':
        target => '/tmp/concat/file',
        group  => 'bar',
      }
    EOS
    w = 'The $group parameter to concat::fragment is deprecated and has no effect'

    it_behaves_like 'has_warning', pp, w
  end

  context 'concat::fragment backup parameter' do
    pp = <<-EOS
      concat { '/tmp/concat/file': }
      concat::fragment { 'foo':
        target => '/tmp/concat/file',
        backup => 'bar',
      }
    EOS
    w = 'The $backup parameter to concat::fragment is deprecated and has no effect'

    it_behaves_like 'has_warning', pp, w
  end

  context 'include concat::setup' do
    pp = <<-EOS
      include concat::setup
    EOS
    w = 'concat::setup is deprecated as a public API of the concat module and should no longer be directly included in the manifest.'

    it_behaves_like 'has_warning', pp, w
  end

end
