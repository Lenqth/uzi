{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Data.Discord.Response.MessageCreateEventResponse
  ( MessageCreateEventResponse,
    channelId,
    content,
    mentions,
    member,
    isBot,
    makeMessageCreateEventResponse,
  )
where

import Control.Lens
import Data.Aeson
import Data.Discord.ChannelId
import Data.Discord.Content
import Data.Discord.Member
import Data.Discord.Mention
import Data.Maybe (fromMaybe)

data MessageCreateEventResponse = MessageCreateEventResponse
  { _channelId :: ChannelId,
    _content :: Content,
    _mentions :: [Mention],
    _member :: Member,
    _isBot :: Bool
  }
  deriving (Show, Eq)

makeLenses ''MessageCreateEventResponse

makeMessageCreateEventResponse :: ChannelId -> Content -> [Mention] -> Member -> Bool -> MessageCreateEventResponse
makeMessageCreateEventResponse = MessageCreateEventResponse

instance FromJSON MessageCreateEventResponse where
  parseJSON = withObject "MessageCreateEventResponse" $ \o -> do
    dataSection <- o .: "d"
    _channelId <- parseJSON @ChannelId =<< dataSection .: "channel_id"
    _content <- parseJSON @Content =<< dataSection .: "content"
    _mentions <- parseJSON @[Mention] =<< dataSection .: "mentions"
    _member <- parseJSON @Member =<< dataSection .: "member"
    _author <- dataSection .: "author"
    _isBot <- fromMaybe False <$> _author .:? "bot"
    pure MessageCreateEventResponse {..}
