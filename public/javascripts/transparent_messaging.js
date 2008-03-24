/* transparent messages for prototype
  VERSION: 1 - 10/18/2007
  idea - http://www.humanized.com/weblog/2006/09/11/monolog_boxes_and_transparent_messages
        jQuery version - http://humanmsg.googlecode.com
  this hackery by mhw@hypomodern.com ~ thanks for the challenge, folks.
*/
var HumaneMessager = {
  setup:function(log, opacity, append_to) {
    HumaneMessager.message_id = "humanMsg";
    HumaneMessager.use_effects = (typeof Effect == "undefined") ? false : true;

    append_to = append_to || "body";
    var elm = (append_to == "body") ? $$('body').first() : $(append_to);
    HumaneMessager.log = Object.isUndefined(log) ? false : log;
    HumaneMessager.opacity = opacity ? parseFloat(opacity) : 0.7;

    //template, just because I love playing with these.
    var message_div = new Template('<div id="#{message_id}" class="humanMsg"><div class="round"></div><p></p><div class="round"></div></div>');
    elm.insert(message_div.evaluate({message_id:HumaneMessager.message_id}));
  },

  displayMessage:function(msg) {
    if(msg == '') { return; }

    clearTimeout(HumaneMessager.t2);

    //inject message
    var container = $(HumaneMessager.message_id);
    container.down('p').update(msg);
    container.setStyle({display:'block'});
    //jQuery's show/hide togglers work better. Interesting. We're reduced to setStyle + display:block in prototype

    if(HumaneMessager.use_effects) {
      new Effect.Opacity(container, {duration:0.3, from:0.0, to:HumaneMessager.opacity, afterFinish:function() { return HumaneMessager.sendToLog(msg); } } );
    } else {
      container.setStyle({opacity:HumaneMessager.opacity});
    }

                //attach window handlers after short delay:
                HumaneMessager.t1 = setTimeout("HumaneMessager.bindEvents()", 750);

                //default: terminate message after 5s
                HumaneMessager.t2 = setTimeout("HumaneMessager.removeMessage()", 5000);
  },

  //logging is decoupled. a sample implementation is below.
  sendToLog:function(msg) {
    if(!HumaneMessager.log) { return; }
    HumaneMessager.log.write(msg);
  },

  removeMessage:function() {
    //clear the event capturing and the timeout:
    ["mousemove", "click", "keypress"].each(function(evt) {
      Event.stopObserving(window, evt, HumaneMessager.removeMessage);
    });
    clearTimeout(HumaneMessager.t2);

    //remove the message:
    var container = $(HumaneMessager.message_id);
    if(HumaneMessager.use_effects) {
      new Effect.Opacity(container, {duration:0.3, to:0, afterFinish:function() { return container.hide(); } } );
    } else {
      container.hide();
    }
  },

  bindEvents:function() {
    ["mousemove", "click", "keypress"].each(function(evt) {
      Event.observe(window, evt, HumaneMessager.removeMessage);
    });
  }
};

//a sample logger implementation, depends on scripty (+ lowpro for the $li, I guess):
var MessageLogger = {
  setup:function(log_name) {
    MessageLogger.id = "humanMsgLog";
    MessageLogger.name = log_name || "Message Log";

    var log = new Template('<div id="#{log_id}"><p>#{log_name}</p><div id="log"><ul></ul></div></div>');
    $$('body').first().insert(log.evaluate({log_id:MessageLogger.id, log_name:MessageLogger.name}));

    //observe the message log handle for clicks:
    $(MessageLogger.id).down('p').observe('click', function() {
      var log = $('log').down('ul');
      log.setStyle({bottom:'0px;'});
      if(log.getStyle('display') == 'none') { return log.setStyle({display:'block'}); }
      return new Effect.toggle(this.next('div#log'), "slide", {duration: 0.3});
    });
  },
  write:function(msg) {
    var container = $(MessageLogger.id);
    var log = container.down('ul');
    if(container.getStyle('display')  == 'none')
      container.setStyle({display:'block'});

    log.prependChild($li().update(msg));

    //the bouncy effect is cute, but surprisingly non-obvious to duplicate in scriptaculous
    if(log.up('div').getStyle('display') == 'none' || log.getStyle('display') == 'none') {
      new Effect.Pulsate(container.down('p'), { pulses: 1, duration: 0.35 });
    }
  }
};