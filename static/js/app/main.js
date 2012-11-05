/*
  IndexView, renders the root path of the webpage.
*/
var IndexView = Backbone.View.extend({
  
  // Put rendered template to `section`.
  el: $('section'),
  
  initialize: function() {
    // Render the view immediately on initialize stage.
    _.bindAll(this, 'render');
    this.render();
  },
  
  // Compile underscore.js template to HTML.
  template: _.template($('#index_template').html()),
  
  render: function() {
    // The following renders the user menu for logged in users etc.
    var t = _.template($('#user_template').html());
    var cookie = $.cookie('fa'); // Get the cookie.
    var cusername = null;
    if(cookie != null) cusername = $.cookie('fa').split('|')[0];
    // Put username to a dict. and then send it to template to be rendered.
    var template_data = {
      'username': cusername
    };
    $('#umenu').remove();
    $('#gmenu').before(t(template_data));
    
    // If there's already a rendered template, then remove it first.
    $(this.el).empty();
    $(this.el).html(this.template); // Show rendered template on `section`.
    return this;
  }
});


// Renders #about page.
var AboutView = Backbone.View.extend({

  // Put rendered template to `section`.
  el: $('section'),

  initialize: function() {
    // Render the view immediately on initialize stage.
    _.bindAll(this, 'render');
    this.render();
  },
  
  // Compile underscore.js template to HTML.
  template: _.template($('#about_template').html()),
  
  render: function() {
    $(this.el).empty();
    $(this.el).html(this.template);
    return this;
  }
});

// Renders #game page.
var GameView = Backbone.View.extend({
  
  el: $('section'),

  initialize: function() {
    _.bindAll(this, 'render');
    this.render();
  },
  
  template: _.template($('#game_template').html()),
  
  render: function() {
    $(this.el).empty();
    $(this.el).html(this.template);
    return this;
  }
});

// Renders #logout
var LogoutView = Backbone.View.extend({
  initialize: function() {
    $.cookie('fa', null); // Delete cookie
    Backbone.history.navigate('', true);
  }
});

var Application = Backbone.Router.extend({
  routes: {
    'logout': 'LogoutHandler',
    'game': 'GameHandler',
    'about': 'AboutHandler',
    '': 'IndexHandler',
  },
  LogoutHandler: function() {
    new LogoutView();
  },
  IndexHandler: function() {
    new IndexView();
  },
  AboutHandler: function() {
    new AboutView();
  },
  GameHandler: function() {
    new GameView();
  },
});

var app = new Application();
Backbone.history.start();
