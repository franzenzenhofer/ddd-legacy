var gulp = require('gulp'),
    gp_concat = require('gulp-concat'),
    gp_rename = require('gulp-rename'),
    gp_uglify = require('gulp-uglify');

gulp.task('js-fef', function(){
    return gulp.src(['./node_modules/two.js/build/two.js', './node_modules/p2/build/p2.js', './node_modules/pleasejs/dist/Please.js', './main.js'])
        .pipe(gp_concat('ddd-in-one-file.js'))
        .pipe(gulp.dest('dist'))
        .pipe(gp_rename('ddd.js'))
        .pipe(gp_uglify())
        .pipe(gulp.dest('dist'));
});

gulp.task('default', ['js-fef'], function(){});
