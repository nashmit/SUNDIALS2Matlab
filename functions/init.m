currentFile = mfilename( 'fullpath' );
[filepath,name,ext] = fileparts( currentFile );
addpath( fullfile(filepath,'../casadi' ) )
import casadi.*
