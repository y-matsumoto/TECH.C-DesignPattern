=begin rdoc
= ClassGenerateHandlerManagerクラス
=end
class ClassGenerateHandlerManager
  attr_accessor :class_generater_handler

  def initialize()
    test_class_generate_handler = TestClassGenerateHandler.new
    abstract_class_generate_handler = AbstractClassGenerateHandler.new
    test_class_generate_handler.next=abstract_class_generate_handler
    
    normal_class_generate_handler = NormalClassGenerateHandler.new
    abstract_class_generate_handler.next = normal_class_generate_handler
    
    @class_generater_handler = test_class_generate_handler
  end

  def generate(class_name)
    return @class_generater_handler.generate class_name
  end
end

=begin rdoc
= ClassGenerateHandlerクラス
=end
class ClassGenerateHandler
  attr_accessor :next
  NOT_OVERRRIDE = 'not override error'

  def generate(class_name)
    if is_target class_name
      return done class_name
    else
      return @next.generate class_name unless @next.nil?
    end
  end

  def is_target(class_name)
    raise WebPage::NOT_OVERRRIDE
  end
  
  def done(class_name)
    raise WebPage::NOT_OVERRRIDE
  end
end

=begin rdoc
= TestClassGenerateHandlerクラス
=end
class TestClassGenerateHandler < ClassGenerateHandler
  def is_target(class_name)
    return true unless class_name.scan(/^Test*/).size == 0
    return false
  end
  
  def done(class_name)
    code =<<"EOS"
public class #{class_name}() extends TestCase {

  setUp() {
  
  }
  
  

  tearDown() {
  
  }
}
EOS

    return code
  end
end


=begin rdoc
= AbstractClassGenerateHandlerクラス
=end
class AbstractClassGenerateHandler < ClassGenerateHandler
  def is_target(class_name)
    return true unless class_name.scan(/^Abstract*/).size == 0
    return false
  end
  
  def done(class_name)
    code =<<"EOS"
public abstract class #{class_name}() {

}
EOS

    return code
  end
end

=begin rdoc
= NormalClassGenerateHandlerクラス
=end
class NormalClassGenerateHandler < ClassGenerateHandler
  def is_target(class_name)
    return true
  end
  
  def done(class_name)
    code =<<"EOS"
public class #{class_name}() {

}
EOS

    return code
  end
end

generate_handler_manager = ClassGenerateHandlerManager.new
class_name = "TestClass"
puts "■#{class_name}を指定"
puts generate_handler_manager.generate class_name

class_name = "AbstractTestClass"
puts "■#{class_name}を指定"
puts generate_handler_manager.generate class_name

class_name = "NotAbstractTestClass"
puts "■#{class_name}を指定"
puts generate_handler_manager.generate class_name